Return-Path: <linux-kernel-owner+w=401wt.eu-S1757746AbYAGOKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746AbYAGOKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 09:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503AbYAGOKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 09:10:23 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:49052 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbYAGOKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 09:10:22 -0500
Message-ID: <478232BB.3040406@linux.vnet.ibm.com>
Date: Mon, 07 Jan 2008 19:40:03 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "riel@redhat.com" <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, lee.schermerhorn@hp.com
Subject: Re: [patch 07/19] split anon & file LRUs for memcontrol code
References: <20080102224144.885671949@redhat.com> <20080102224154.309980291@redhat.com> <20080107190455.22412330.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080107190455.22412330.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 02 Jan 2008 17:41:51 -0500
> linux-kernel@vger.kernel.org wrote:
> 
>> Index: linux-2.6.24-rc6-mm1/mm/vmscan.c
>> ===================================================================
>> --- linux-2.6.24-rc6-mm1.orig/mm/vmscan.c	2008-01-02 15:55:55.000000000 -0500
>> +++ linux-2.6.24-rc6-mm1/mm/vmscan.c	2008-01-02 15:56:00.000000000 -0500
>> @@ -1230,13 +1230,13 @@ static unsigned long shrink_zone(int pri
>>  
>>  	get_scan_ratio(zone, sc, percent);
>>  
> 
> I'm happy if this calclation can be following later.
> ==
> if (scan_global_lru(sc)) {
> 	get_scan_ratio(zone, sc, percent);
> } else {
> 	get_scan_ratio_cgroup(sc->cgroup, sc, percent);
> }
> ==
> To do this, 
> mem_cgroup needs to have recent_rotated_file and recent_rolated_anon ?

Yes, that makes sense.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
