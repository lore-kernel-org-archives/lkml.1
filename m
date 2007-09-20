Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbXITMFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbXITMFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 08:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbXITMFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 08:05:45 -0400
Received: from il.qumranet.com ([82.166.9.18]:52519 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbXITMFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 08:05:44 -0400
Message-ID: <46F26208.309@qumranet.com>
Date: Thu, 20 Sep 2007 14:05:28 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jesse Barnes <jesse.barnes@intel.com>, Howard Chu <hyc@symas.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: MTRR initialization
References: <46EAB7DA.10507@symas.com>	<200709191452.57505.jesse.barnes@intel.com> <p73d4wdal00.fsf@bingen.suse.de>
In-Reply-To: <p73d4wdal00.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Jesse Barnes <jesse.barnes@intel.com> writes:
>   
>> To do this in a nicer way (and be less vulnerable to similar BIOS 
>> funkiness) the kernel really needs full PAT support.  That should allow 
>> WC over WB and WC over UC mappings to occur, at least if I'm 
>> remembering the docs right...
>>     
>
> PAT only really helps for device driver performance optimizations.
> But if the basic WB MTRRs are wrong PAT cannot really salvage it. 
>   

Is there any reason not to set the MTRRs to define the entire memory as 
write back, and use PAT exclusively for setting cacheability?

On my home machine for instance, the BIOS uses all 8 MTRRs leaving none 
for X.  I hacked it by merging a couple of MTRRs but this isn't a 
generic solution.

-- 
error compiling committee.c: too many arguments to function

