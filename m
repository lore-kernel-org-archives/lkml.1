Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbZGCUFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbZGCUFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 16:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756588AbZGCUF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 16:05:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58192 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365AbZGCUF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 16:05:29 -0400
Message-ID: <4A4E6374.5060302@zytor.com>
Date: Fri, 03 Jul 2009 13:00:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: lkml@morethan.org
CC: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [Bug Fix]: Do 32-bit table calculations in pre-processor
References: <200907031314.36243.lkml@morethan.org> <4A4E57FA.4000609@goop.org> <4A4E5974.7030507@zytor.com> <200907031446.49085.lkml@morethan.org>
In-Reply-To: <200907031446.49085.lkml@morethan.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Zick wrote:
> On Fri July 3 2009, H. Peter Anvin wrote:
>> Jeremy Fitzhardinge wrote:
>>> Hm, well that does sound serious, but I think you're barking up the
>>> wrong tree with this particular patch.
>>>
>> Well, if it changes behavior it's an indication that the version of gas
>> he's using is broken (or possibly very old.)  What version is it?
>>
> 
> Whatever Gentoo was shipping with 4.1 - -
> System and operator are down for lunch at the moment -
> I'll look it up and reply soonest.
> 
> Scroll back up to my first post - it does make a difference
> with this tool-chain - exactly difference expected if the
> tool chain is doing 32-bit calculations.
> 
> And since it is a "*.S" file - I think cpp is doing it not gas/as.
> 

You're wrong.  cpp will expand the constants, but as will actually do
the calculation.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

