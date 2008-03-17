Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbYCQBr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbYCQBr5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 21:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbYCQBru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 21:47:50 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46000 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbYCQBrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 21:47:49 -0400
Message-ID: <47DDCDA7.4020108@cn.fujitsu.com>
Date: Mon, 17 Mar 2008 10:47:19 +0900
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org,
       taka@valinux.co.jp, David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][0/3] Virtual address space control for cgroups
References: <20080316172942.8812.56051.sendpatchset@localhost.localdomain> <6599ad830803161626q1fcf261bta52933bb5e7a6bdd@mail.gmail.com>
In-Reply-To: <6599ad830803161626q1fcf261bta52933bb5e7a6bdd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Mon, Mar 17, 2008 at 1:29 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> This is an early patchset for virtual address space control for cgroups.
>>  The patches are against 2.6.25-rc5-mm1 and have been tested on top of
>>  User Mode Linux.
> 
> What's the performance hit of doing these accounting checks on every
> mmap/munmap? If it's not totally lost in the noise, couldn't it be
> made a separate control group, so that it could be just enabled (and
> the performance hit taken) for users that actually want it?
> 

It will be code duplication to make it a new subsystem, and it will be useful
to control both of them, am I right? :)

So could we just add a CONFIG to this patch series, like:
	CONFIG_CGROUP_MEM_RES_AS_CTLR
?

> Paul
> 
> 
