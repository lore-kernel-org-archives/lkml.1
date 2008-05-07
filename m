Return-Path: <linux-kernel-owner+w=401wt.eu-S933092AbYEGHuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092AbYEGHuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758708AbYEGHty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:49:54 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:14869 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758857AbYEGHtw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:49:52 -0400
Message-Id: <48217B5F.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Wed, 07 May 2008 08:50:23 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Cc: <odie@cs.aau.dk>, "Ingo Molnar" <mingo@elte.hu>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Chuck Ebbert" <cebbert@redhat.com>, <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Please revert 709f744 (x86: bitops asm constraint fixes)
References: <1209995129.5172.19.camel@odie.local>
 <20080506120155.GG32591@elte.hu> <482175EF.76E4.0078.0@novell.com>
 <alpine.LFD.1.10.0805070940060.3318@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805070940060.3318@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Thomas Gleixner <tglx@linutronix.de> 07.05.08 09:43 >>>
>On Wed, 7 May 2008, Jan Beulich wrote:
>> >>> Ingo Molnar <mingo@elte.hu> 06.05.08 14:01 >>>
>> >Jan, any ideas what's wrong with your commit?
>> 
>> No, I have no idea at all (apart from considering mis-compilation as you
>> did. The best path I could suggest is to try and nail this down to one
>> (or more, if that happens to be the case) function(s) having been
>> changed - this is mostly because part of the changes are really
>> tightening things (which therefore I would think ought to be kept),
>> while the change to __test_and_change_bit() really weakens things
>> (which I nevertheless continue to think is correct and consistent with
>> other functions, but which then would be the primary suspect). Of
>> course, since no-one else has seen this so far, this would need to be
>> done by Simon.
>> Once down to a single (hopefully) function, it might be possible to just
>> statically compare the two vmlinux-es to perhaps spot whether this
>> indeed is mis-compilation.
>
>Jan,
>
>can you please provide a step by step conversion of those constraints
>on top of the revert. I'm a bit wary about this whole business as such
>constraint problems might hit us elsewhere as well.

I certainly can, but I can't promise when I'd get to do this (may be days
to weeks - sorry for that).

Jan

