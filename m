Return-Path: <linux-kernel-owner+w=401wt.eu-S1755087AbYCKKPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbYCKKPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 06:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbYCKKPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 06:15:03 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:40152 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbYCKKPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 06:15:01 -0400
Message-ID: <47D65B99.3070208@linux.vnet.ibm.com>
Date: Tue, 11 Mar 2008 15:44:49 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 3/3] memcgoup: allow memory.failcnt to be reset
References: <47D65A3E.100@cn.fujitsu.com> <20080311191649.32a2cbae.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080311191649.32a2cbae.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Tue, 11 Mar 2008 19:09:02 +0900
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> Allow memory.failcnt to be reset to 0:
>>
>>         echo 0 > memory.failcnt
>>
>> And '0' is the only valid value.
>>
> Can't this be generic resource counter function ?
> 

I was about to suggest a generic cgroup option, since we do reset values even
for the cpu accounting subsystem.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
