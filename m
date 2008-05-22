Return-Path: <linux-kernel-owner+w=401wt.eu-S936515AbYEVKPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936515AbYEVKPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 06:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933330AbYEVKPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 06:15:11 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:54641 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936450AbYEVKPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 06:15:09 -0400
Message-ID: <4835476A.3020506@linux.vnet.ibm.com>
Date: Thu, 22 May 2008 15:44:02 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm][PATCH 2/4] Setup the memrlimit controller (v5)
References: <20080521152921.15001.65968.sendpatchset@localhost.localdomain> <20080521152948.15001.39361.sendpatchset@localhost.localdomain> <20080521211833.bc7c5255.akpm@linux-foundation.org>
In-Reply-To: <20080521211833.bc7c5255.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 21 May 2008 20:59:48 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> +static int memrlimit_cgroup_write_strategy(char *buf, unsigned long long *tmp)
> 
> grumble.  I think I requested a checkpatch warning whenever it comes
> across "tmp" or "temp".  Even better would be a gcc coredump.
> 

:-)

> I'm sure there's something more meaningful we could use here?

I'll send a patch to fix this.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
