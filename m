Return-Path: <linux-kernel-owner+w=401wt.eu-S1760935AbYBOXTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760935AbYBOXTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 18:19:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYBOXS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 18:18:57 -0500
Received: from ishtar.tlinx.org ([64.81.245.74]:39014 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238AbYBOXSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 18:18:55 -0500
Message-ID: <47B61DDF.4000302@tlinx.org>
Date: Fri, 15 Feb 2008 15:18:55 -0800
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86-32-config: why is pc-speaker an input device?
References: <47B601CF.9070300@tlinx.org> <4387.1203112503@turing-police.cc.vt.edu>
In-Reply-To: <4387.1203112503@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> The last time around for this question, I was half-paying attention, and
> the rationale sounded like "We had an input device framework, no output
> device framework, and too many bad shrooms to do something comprehensible".
>   
---
    Yeah, hmm...the question I'd have then is the "only" output device 
that doesn't fit into a better category? 

    Could there be other OUTput devices in this category?   Would
renaming the category to something like "Miscellaneous I/O Devices" be
reasonable?    Are keyboard status lights considered output devices?
Are "force-feedback" devices meaning devices like a rumble-gamepad
device?  Isn't that providing output via feedback?

    Though, I would agree, most of these devices would be thought of
as "input" devices. Dang PC-SPEAKER...um...since the driver is config'ed
with the 'input' interface, dang, it really seems like it should be an
entry under sound.

    I can see the problem and I'm not familiar enough with the underlying
drivers to know how the PC-Speaker would best be handled. 

> (This is such a *frequent* FAQ, even all the time since 2.6.0 escaped, that
> maybe we need to add a 3-4 line explain to the Kconfig 'help' stanza for
> CONFIG_INPUT_PCSPKR - although for some reason, INPUT_SPARCSPKR and
> INPUT_M68K_BEEP don't seem to cause the same questions....)
>   
----
No matter where it is in the 'kernel configuration', it sure seems
strange (in "user land"), to see the PC-Speaker be recognized as an
input device -- especially in light of the fact that "all speakers
are microphones" (http://www.zyra.org.uk/sp-mic.htm).  Would some user
wonder whether or not their speaker has some dual-circuitry to listen
as well as output (ala TV sets being 2-way video devices in Max Headroom)?



