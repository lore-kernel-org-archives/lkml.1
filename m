Return-Path: <linux-kernel-owner+w=401wt.eu-S1752448AbYHSEBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbYHSEBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 00:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbYHSEB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 00:01:29 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:56708 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750788AbYHSEB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 00:01:29 -0400
Message-ID: <48AA4594.1000908@linux.vnet.ibm.com>
Date: Tue, 19 Aug 2008 09:31:24 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Ryo Tsuruta <ryov@valinux.co.jp>
CC: kamezawa.hiroyu@jp.fujitsu.com, xen-devel@lists.xensource.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, dm-devel@redhat.com,
       agk@sourceware.org, xemul@openvz.org, fernando@oss.ntt.co.jp
Subject: Re: [PATCH 4/7] bio-cgroup: Split the cgroup memory subsystem into
 two parts
References: <20080812.213449.104039151.ryov@valinux.co.jp> <20080812.213533.189720227.ryov@valinux.co.jp> <20080818103938.8b4e8bfa.kamezawa.hiroyu@jp.fujitsu.com> <20080819.122811.59660409.ryov@valinux.co.jp>
In-Reply-To: <20080819.122811.59660409.ryov@valinux.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryo Tsuruta wrote:
> Hi Kamezawa-san,
> 
>> I'm now writing remove-lock-page-cgroup patches. it works well.
>> please wait for a while...
> 
> I'm looking forward to those patches.
> 
> By the way, I'm glad if memory-cgroup has a feature which can make a
> page_cgroup move between cgroups with small overhead. It makes
> bio-cgroup improve the accuracy of tracking down pages.

Page movement can be a very expensive operation and is proportional to the size
of the control group. I think movement should be an optional feature, if we ever
add it.

-- 
	Balbir
