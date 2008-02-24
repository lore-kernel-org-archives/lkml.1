Return-Path: <linux-kernel-owner+w=401wt.eu-S1757733AbYBXCw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733AbYBXCw6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 21:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbYBXCwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 21:52:51 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:59481 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbYBXCwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 21:52:50 -0500
Message-ID: <47C0DAD8.8050401@linux.vnet.ibm.com>
Date: Sun, 24 Feb 2008 08:17:52 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, xemul@openvz.org, balbir@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] ResCounter: Use read_uint in memory controller
References: <20080221203518.544461000@menage.corp.google.com> <20080221205525.349180000@menage.corp.google.com> <47BE4FB5.5040902@linux.vnet.ibm.com> <6599ad830802230633i483c8dd1q5b541be1a92a5795@mail.gmail.com> <20080223105933.e6884808.akpm@linux-foundation.org>
In-Reply-To: <20080223105933.e6884808.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 23 Feb 2008 06:33:34 -0800 "Paul Menage" <menage@google.com> wrote:
> 
>> On Thu, Feb 21, 2008 at 8:29 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>>  Looks good, except for the name uint(), can we make it u64(). Integers are 32
>>>  bit on both ILP32 and LP64, but we really read/write 64 bit values.
>> Yes, that's true. But read_uint() is more consistent with all the
>> other instances in cgroups and subsystems. So if we were to call it
>> res_counter_read_u64() I'd also want to rename all the other
>> *read_uint functions/fields to *read_u64 too. Can I do that in a
>> separate patch?
>>
> 
> Sounds sensible to me.
> 

Sure, fair enough.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
