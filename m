Return-Path: <linux-kernel-owner+w=401wt.eu-S1756527AbXFLMgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbXFLMgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 08:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbXFLMgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 08:36:42 -0400
Received: from styx.suse.cz ([82.119.242.94]:48912 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751730AbXFLMgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 08:36:41 -0400
Date: Tue, 12 Jun 2007 14:37:54 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Renato Golin <rengolin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: joydev.c and saitek cyborg evo force
In-Reply-To: <d9b9d95f0706041546h4eef0b4eo2e191968be13d59a@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706121436070.10204@jikos.suse.cz>
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com> 
 <Pine.LNX.4.64.0705301654560.3961@jikos.suse.cz> 
 <d9b9d95f0705300818h2eaa8130mf8a7a37966d29cc5@mail.gmail.com> 
 <d9b9d95f0705301526i66e99ef3v6c35165aa1a5f5c6@mail.gmail.com> 
 <d120d5000705311253n67d4247eh194e6f4457a0b4c@mail.gmail.com> 
 <Pine.LNX.4.64.0705312220250.5177@jikos.suse.cz> 
 <d9b9d95f0706011116j59fff917x9a86aac377f88937@mail.gmail.com> 
 <Pine.LNX.4.64.0706031139570.5177@jikos.suse.cz> 
 <d9b9d95f0706041506l257819a7pbcb8b8efc2eec049@mail.gmail.com> 
 <Pine.LNX.4.64.0706050008160.5177@jikos.suse.cz>
 <d9b9d95f0706041546h4eef0b4eo2e191968be13d59a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Renato Golin wrote:

> > sorry, don't fully understand - what do you mean by "got the messages 
> > but not the fix"?
> The range "detected" was 0 to 255 but both X and Y axis are reporting 
> 4096.
> I think that the code in drivers/hid/hid-input.c:
> if ((device->quirks & HID_QUIRK_BADPAD) && (usage->code == ABS_X ||
> usage->code == ABS_Y)) {
>  a = field->logical_minimum = 0;
>  b = field->logical_maximum = 255;
> }

Hi Renato,

the thing is that the aim of this quirk is to normalize the values that 
are being reported by bogus devices, so we don't really want to trust the 
values they provide here, do we?

Thanks,

-- 
Jiri Kosina
SUSE Labs
