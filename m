Return-Path: <linux-kernel-owner+w=401wt.eu-S1764123AbYCGNBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764123AbYCGNBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 08:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758129AbYCGNBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 08:01:42 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:58327 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757522AbYCGNBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 08:01:41 -0500
Message-ID: <47D13BF1.1060009@linux.vnet.ibm.com>
Date: Fri, 07 Mar 2008 18:28:25 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Add cgroup support for enabling controllers at boot time
 (v2)
References: <20080307085735.25567.314.sendpatchset@localhost.localdomain> <6599ad830803070125o1ebfd7d1r728cdadf726ecbe2@mail.gmail.com> <6599ad830803070426l22d78446t588691dedeeb490b@mail.gmail.com>
In-Reply-To: <6599ad830803070426l22d78446t588691dedeeb490b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Fri, Mar 7, 2008 at 1:25 AM, Paul Menage <menage@google.com> wrote:
>>  Doesn't this mean that cgroup_disable=cpu will disable whichever comes
>>  first out of cpuset, cpuacct or cpu in the subsystem list?
> 
> Or rather, it's the other way around - cgroup_disable=cpuset will
> instead disable the "cpu" subsystem if "cpu" comes before "cpuset" in
> the subsystem list.
> 

Would it? I must be missing something, since we do a strncmp with ss->name.
I would expect that to match whole strings.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
