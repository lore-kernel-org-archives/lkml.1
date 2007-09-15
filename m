Return-Path: <linux-kernel-owner+w=401wt.eu-S1759407AbXIOJnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407AbXIOJnv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 05:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbXIOJnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 05:43:42 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44071 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbXIOJnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 05:43:41 -0400
Date: Sat, 15 Sep 2007 11:43:40 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Denys Vlasenko <vda.linux@googlemail.com>
cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add consts where appropriate in sound/pci/hda/*
In-Reply-To: <200709141848.06027.vda.linux@googlemail.com>
Message-ID: <Pine.LNX.4.64.0709151143230.13411@fbirervta.pbzchgretzou.qr>
References: <200709141848.06027.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 14 2007 18:48, Denys Vlasenko wrote:
>Hi Takashi,
>
>There is a lot of data structures in that code,
>and most of them seems to be read-only.
>
>I added const modifiers to most of such places:
>
>   text    data     bss     dec     hex filename
> 106315  179564      36  285915   45cdb snd-hda-intel.o
> 283051    2624      36  285711   45c0f snd-hda-intel_patched.o

This is kinda odd. Why did the _text_ size increase by constifying?


