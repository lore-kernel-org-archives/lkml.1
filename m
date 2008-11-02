Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbYKBPxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbYKBPxF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 10:53:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbYKBPwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 10:52:54 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:54211 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbYKBPwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 10:52:53 -0500
Message-ID: <490DCCC9.5000508@linux.vnet.ibm.com>
Date: Sun, 02 Nov 2008 21:22:41 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [mm] [PATCH 4/4] Memory cgroup hierarchy feature selector
References: <20081101184812.2575.68112.sendpatchset@balbir-laptop> <20081101184902.2575.11443.sendpatchset@balbir-laptop> <20081102143817.99edca6d.kamezawa.hiroyu@jp.fujitsu.com> <490D42C7.4000301@linux.vnet.ibm.com> <20081102152412.2af29a1b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081102152412.2af29a1b.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Sun, 02 Nov 2008 11:33:51 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> KAMEZAWA Hiroyuki wrote:
>>> On Sun, 02 Nov 2008 00:19:02 +0530
>>> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>>
>>>> Don't enable multiple hierarchy support by default. This patch introduces
>>>> a features element that can be set to enable the nested depth hierarchy
>>>> feature. This feature can only be enabled when there is just one cgroup
>>>> (the root cgroup).
>>>>
>>> Why the flag is for the whole system ?
>>> flag-per-subtree is of no use ?
>> Flag per subtree might not be useful, since we charge all the way up to root,
> Ah, what I said is "How about enabling/disabling hierarhcy support per subtree ?"
> Sorry for bad text.
> 
> like this.
>   - you can set hierarchy mode of a cgroup turned on/off when...
>     * you don't have any tasks under it && it doesn't have any child cgroup.

That should not be hard, but having it per-subtree sounds a little complex in
terms of exploiting from the end-user perspective and from symmetry perspective
(the CPU cgroup controller provides hierarchy control for the full hierarchy).

-- 
	Balbir
