Return-Path: <linux-kernel-owner+w=401wt.eu-S932160AbXHVTUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbXHVTUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 15:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758352AbXHVTUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 15:20:21 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:49165 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbXHVTUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 15:20:19 -0400
Message-ID: <46CC8C6A.7080904@linux.vnet.ibm.com>
Date: Thu, 23 Aug 2007 00:50:10 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Containers <containers@lists.osdl.org>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Dave Hansen <haveblue@us.ibm.com>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       Nick Piggin <npiggin@suse.de>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric W Biederman <ebiederm@xmission.com>
Subject: Re: [PATCH] Memory controller Add Documentation
References: <20070822130612.18981.58696.sendpatchset@balbir-laptop> <6599ad830708221218t3c1eae51o1605f00b8f204b02@mail.gmail.com>
In-Reply-To: <6599ad830708221218t3c1eae51o1605f00b8f204b02@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On 8/22/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>
>> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
>> ---
>>
>>  Documentation/memcontrol.txt |  193 +++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 193 insertions(+)
>>
>> diff -puN /dev/null Documentation/memcontrol.txt
>> --- /dev/null   2007-06-01 20:42:04.000000000 +0530
>> +++ linux-2.6.23-rc2-mm2-balbir/Documentation/memcontrol.txt    2007-08-22 18:29:29.000000000 +0530
>> @@ -0,0 +1,193 @@
>> +Memory Controller
>> +
>> +0. Salient features
>> +
>> +a. Enable control of both RSS and Page Cache pages
> 
> s/RSS/anonymous/ (and generally throughout the document)? RSS can
> include pages that are part of the page cache too.
> 
> Paul

Yes, thats a good point. I'll clean up the documentation.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
