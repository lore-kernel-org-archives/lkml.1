Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbZCZALr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbZCZALr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 20:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbZCZALj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 20:11:39 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:57211 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbZCZALj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 20:11:39 -0400
Date: Wed, 25 Mar 2009 17:11:34 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       shai@scalex86.org
Subject: Re: [PATCH] x86: don't compile vsmp_64 for 32bit
Message-ID: <20090326001134.GM7278@localdomain>
References: <20090302235120.GF27240@localdomain> <20090322124818.GA31466@elte.hu> <20090324061429.GH7278@localdomain> <20090324091035.GA6605@elte.hu> <20090325185138.GI7278@localdomain> <49CAAD2E.3060904@goop.org> <20090325223642.GK7278@localdomain> <49CABB25.8040106@goop.org> <20090325232921.GL7278@localdomain> <alpine.LFD.2.00.0903260034200.3397@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903260034200.3397@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 12:36:11AM +0100, Thomas Gleixner wrote:
>On Wed, 25 Mar 2009, Ravikiran G Thirumalai wrote:
>> > Sure, but it would be cleaner if the whole file were controlled by 
>> > CONFIG_X86_VSMP.  is_vsmp_box() is already defined as const inline 
>> > returning 0 if !CONFIG_X86_VSMP.
>> >
>> 
>> The point in this thread was, is_vsmp_box() needs to be meaningful even when
>> CONFIG_X86_VSMP is not on.  This is needed because is_vsmp_box() is used to
>> determine if the platform has reliable tscs.
>
>Did you even read what Jeremy wrote or bother to look at the code in
>arch/x86/include/asm/apic.h ?
>

Might I politely point out the origin of this code:
http://lkml.org/lkml/2009/2/26/5

Please note the subject of the patch in the link and the subject of this
discussion.  It is the same thread.  The patch was commited to tip and is
still being discussed if it is any clarification :)

