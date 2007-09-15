Return-Path: <linux-kernel-owner+w=401wt.eu-S1756724AbXIOK3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbXIOK3X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 06:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbXIOK3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 06:29:16 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:55667 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbXIOK3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 06:29:16 -0400
Date: Sat, 15 Sep 2007 12:29:15 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Denys Vlasenko <vda.linux@googlemail.com>, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add consts where appropriate in sound/pci/hda/*
In-Reply-To: <20070915101811.GA9934@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0709151228360.13411@fbirervta.pbzchgretzou.qr>
References: <200709141848.06027.vda.linux@googlemail.com>
 <Pine.LNX.4.64.0709151143230.13411@fbirervta.pbzchgretzou.qr>
 <20070915101811.GA9934@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 15 2007 12:18, Sam Ravnborg wrote:
>> >   text    data     bss     dec     hex filename
>> > 106315  179564      36  285915   45cdb snd-hda-intel.o
>> > 283051    2624      36  285711   45c0f snd-hda-intel_patched.o
>> 
>> This is kinda odd. Why did the _text_ size increase by constifying?
>
>The data got converted from data to text because they were made const.

Which is odd. How can data become code? Or does 'text' actually
include .rodata?

>Making stuff const unfortunately does not make them disappear
>albeit the embedded folks would have liked that.
