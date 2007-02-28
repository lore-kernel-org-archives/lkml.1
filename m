Return-Path: <linux-kernel-owner+w=401wt.eu-S932517AbXB1Wb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517AbXB1Wb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 17:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932567AbXB1Wb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 17:31:56 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:49906 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932517AbXB1Wbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 17:31:55 -0500
Date: Wed, 28 Feb 2007 23:30:13 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Ian Molton <spyro@f2s.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] udivdi3: 64 bit divide
In-Reply-To: <45E4B33D.8080705@f2s.com>
Message-ID: <Pine.LNX.4.61.0702282327410.23355@yvahk01.tjqt.qr>
References: <20070226173517.66bf0fec@freekitty> <20070227122437.da27c3cd.akpm@linux-foundation.org>
 <20070227131840.672d6932@localhost> <20070227133656.c452fbb4.akpm@linux-foundation.org>
 <20070227222430.GC10380@flint.arm.linux.org.uk> <45E4B33D.8080705@f2s.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 27 2007 22:39, Ian Molton wrote:
> Russell King wrote:
>> On Tue, Feb 27, 2007 at 01:36:56PM -0800, Andrew Morton wrote:
>> > On Tue, 27 Feb 2007 13:18:40 -0800 Stephen Hemminger
>> > <shemminger@linux-foundation.org> wrote:
>> > > Then we should pull the existing udivdi3 implementations?
>> > >
>> > Not much point really.  Some architectures have gone
>> > and done that, but x86 has not.  x86 has enough
>> > coverage for us to pick up most problems, and any
>> > remaining problems are obviously in scruffy
>> > architectures which don't care about performance ;)
>> 
>> I doubt arm26 uses udivdi3, but that's something Ian
>> would have to confirm.
>
> I doubt it is used also, however I am not in a position
> to test this until at least after I have moved house.
> Please leave alone for now.

Simple. The non-arch specific code does not use 64/64
divides through the "/" operator (otherwise there would
already have been udivdi3 linking errors). So what
remains to check is arch/arm26. grep -Pr 'int64|\bu64'
returns only a few results to check (kernel/ecard.c,
nwfpe/), so the answer is most likely no.



Jan
-- 
