Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbYCKFHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbYCKFHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 01:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbYCKFHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 01:07:46 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:41218 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbYCKFHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 01:07:46 -0400
Message-ID: <47D61395.1010801@linux.vnet.ibm.com>
Date: Tue, 11 Mar 2008 10:37:33 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20080131)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: +
References: <20080311043149.20251.50059.sendpatchset@localhost.localdomain> <20080311135933.8937.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080311135933.8937.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Hi
> 
>> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
>> ---
>>
>>  linux/memcontrol.h |    0 
> 
> ???
> unnecessary hunk?
> or diff comannd bug?

I use Andrew Morton's patchutils and specified both include/linux/memcontrol.h
and mm/memcontrol.c

$ cat pc/memory-controller-move-to-own-slab.pc
mm/memcontrol.c
include/linux/memcontrol.h

But refpatch generates linux/memcontrol.h. I am using diffstat v1.41. I'll
reboot to FC8 and see if that makes any difference.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
