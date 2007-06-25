Return-Path: <linux-kernel-owner+w=401wt.eu-S1751147AbXFYW3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751147AbXFYW3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 18:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbXFYW3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 18:29:24 -0400
Received: from lucidpixels.com ([75.144.35.66]:44718 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbXFYW3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 18:29:23 -0400
Date: Mon, 25 Jun 2007 18:29:18 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Jesse Barnes <jesse.barnes@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
In-Reply-To: <200706251505.21722.jesse.barnes@intel.com>
Message-ID: <Pine.LNX.4.64.0706251828330.3463@p34.internal.lan>
References: <200706251434.43863.jesse.barnes@intel.com>
 <20070625150127.3a45f66d.akpm@linux-foundation.org> <200706251505.21722.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 25 Jun 2007, Jesse Barnes wrote:

> On Monday, June 25, 2007 3:01:27 Andrew Morton wrote:
>> On Mon, 25 Jun 2007 14:34:42 -0700
>>
>> Jesse Barnes <jesse.barnes@intel.com> wrote:
>>> akpm -- this one should replace all the mtrr patches currently
>>> in your tree.
>>
>> fear, uncertainty, doubt.
>>
>> box:/usr/src/25> grep mtrr series
>> x86_64-mm-bug-in-i386-mtrr-initialization.patch
>> x86-fix-section-mismatch-warnings-in-mtrr.patch
>> i386-x86_64-trim-memory-not-covered-by-wb-mtrrs.patch
>> i386-x86_64-trim-memory-not-covered-by-wb-mtrrs-fix.patch
>> i386-x86_64-trim-memory-not-covered-by-wb-mtrrs-fix-2.patch
>> i386-mtrr-clean-up-usage_table.patch
>>
>> Not all of those, I'm sure.  I think you're referring to the final
>> four.  I guess if it doesn't compile (again) I'll find out ;)
>
> Oops, correct.  I forgot you were carrying some MTRR patches not
> authored by me.  :)  Yeah, the last four are the ones I meant.
>
> Thanks,
> Jesse
>

Hi Jesse,

Tested your patch against 2.6.22-rc6, working good so far!

$ uname -r
2.6.22-rc6

Mem:   8039576k total,  1056500k used,  6983076k free,     2420k buffers
Swap: 16787768k total,        0k used, 16787768k free,   127128k cached

Justin.

