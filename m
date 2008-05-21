Return-Path: <linux-kernel-owner+w=401wt.eu-S936670AbYEUSUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936670AbYEUSUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932999AbYEUSUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:20:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756902AbYEUSUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:20:12 -0400
Message-ID: <483466B0.6000606@redhat.com>
Date: Wed, 21 May 2008 13:15:12 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pavel Machek <pavel@suse.cz>, Chris Mason <chris.mason@oracle.com>,
       Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
References: <482DDA56.6000301@redhat.com>	<20080518211140.b29bee30.akpm@linux-foundation.org>	<200805191316.27551.chris.mason@oracle.com>	<200805191439.36577.chris.mason@oracle.com>	<20080521112224.GD5028@ucw.cz> <20080521110324.668048e0.akpm@linux-foundation.org>
In-Reply-To: <20080521110324.668048e0.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 21 May 2008 13:22:25 +0200 Pavel Machek <pavel@suse.cz> wrote:

>>> I tested this one with a larger FS (40GB instead of 2GB) and larger log (128MB 
>>> instead of 32MB).  barrier-test -s 32 -p 1500 was still able to get a 50% 
>>> corruption rate on the larger FS.
>> Ok, Andrew, is this enough to get barrier patch applied and stop
>> corrupting data in default config, or do you want some more testing?
>>
>> I guess 20% benchmark regression is bad, but seldom and impossible to
>> debug data corruption is worse...
> 
> It is 20%?  I recall 30% from a few years ago, but that's vague and it
> might have changed.  Has much quantitative testing been done recently? 
> I might have missed it.
> 
> If we do make this change I think it should be accompanied by noisy
> printks so that as many people as possible know about the decision
> which we just made for them.
> 
> afaik there is no need to enable this feature if the machine (actually
> the disks) are on a UPS, yes?

As long as your power supply (or your UPS) doesn't go boom, I suppose so.

It is too bad that there is no way to determine no-barrier safety from
software.  (maybe apcupsd could do something... ;)

I guess it's levels of confidence.  I agree that a user education
campaign is probably in order... maybe if this thread is long enough to
make LWN it'll raise some awareness.  :)

-Eric
