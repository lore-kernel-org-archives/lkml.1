Return-Path: <linux-kernel-owner+w=401wt.eu-S1946162AbXBPSCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946162AbXBPSCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 13:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946169AbXBPSCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 13:02:23 -0500
Received: from mail.queued.net ([207.210.101.209]:3433 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946162AbXBPSCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 13:02:22 -0500
Message-ID: <45D5F1BA.4030102@debian.org>
Date: Fri, 16 Feb 2007 13:02:34 -0500
From: Andres Salomon <dilinger@debian.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] Input: psmouse - create PS/2 protocol options for
 Kconfig
References: <45D43115.6060806@debian.org> <45D50101.60802@debian.org>	 <20070215173024.adc54d6c.akpm@linux-foundation.org>	 <200702160028.09251.dtor@insightbb.com> <45D54260.7080302@debian.org> <d120d5000702160742v14ac197eica567a15cc1e85d4@mail.gmail.com>
In-Reply-To: <d120d5000702160742v14ac197eica567a15cc1e85d4@mail.gmail.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On 2/16/07, Andres Salomon <dilinger@debian.org> wrote:
>> Dmitry Torokhov wrote:
>> > On Thursday 15 February 2007 20:30, Andrew Morton wrote:
>> >> On Thu, 15 Feb 2007 19:55:29 -0500
>> >> Andres Salomon <dilinger@debian.org> wrote:
>> [...]
>> >> Perhaps a nicer implementation would be to have a separate .c file
>> for each
>> >> variant.
>> >>
>> >
>> > Having completely separate sub-drivers is very hard because of very
>> delicate
>> > PS/2 protocol probing....
>> >
>> > What do you think about patch below? It somewhat reduces #ifdef
>> clutter in main
>> > module moving it in .h files...
>> >
>>
>> Normally, I'm a fan of that sort of thing.  However, in this case, I
>> think it makes sense to have the #ifdefs right in the probe function; at
>> least for me, it makes it easier to understand what's going on.  The
>> synaptics stuff is especially tricky; with a cursory glance over the
>> code, one might assume that all the synaptics functions disappear when
>> CONFIG_MOUSE_PS2_SYNAPTICS is unset.  However, if the #ifdef's are in
>> the probe function, it's pretty clear that some synaptics functions
>> still get called even when CONFIG_MOUSE_PS2_SYNAPTICS is unset.
>>
> 
> Thit is a valid point but #ifdef maze in the middle of already messy
> psmouse-extensions() is too much for me. I guess I will just add a
> comment explaining that synaptics probing is really special.

Fair enough.  Anything you need me to do to move that along?  :)

> 
> Btw, can I get that OLPC patch when you have time?
> 

There are some hardware workarounds (sigh) that need cleaning up, then
I'll submit it.

