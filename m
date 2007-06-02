Return-Path: <linux-kernel-owner+w=401wt.eu-S1760747AbXFBH5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760747AbXFBH5f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 03:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbXFBH53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 03:57:29 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:50853 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbXFBH52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 03:57:28 -0400
Date: Sat, 2 Jun 2007 09:58:45 +0200
From: DervishD <lkml@dervishd.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Kernel utf-8 handling
Message-ID: <20070602075845.GC20406@DervishD>
Mail-Followup-To: "H. Peter Anvin" <hpa@zytor.com>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <20070601142058.GA2587@DervishD> <Pine.LNX.4.61.0706012117250.11140@yvahk01.tjqt.qr> <46609C8B.4000606@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46609C8B.4000606@zytor.com>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi H. Peter :)

 * H. Peter Anvin <hpa@zytor.com> dixit:
> Jan Engelhardt wrote:
> > (1) I can do <Compose><~><n> just fine on vt
> > (2) I can do <ö> just fine on vt too
> > (3) And copy+paste them both using GPM too, again w/o probs
> 
> Both of those are in the 0-255 range, though.  I thought the issue was
> with characters 256+, like ??.  At least on my FC6 system that doesn't
> work with gpm.

    By now, to fully switch to utf-8, I only need to have áéíóúñ and
their uppercase counterparts (for people who cannot see the chars, they
are the acute accented vowels and the ntilde). I really hope that, in
the future, there are a way of fully use Unicode (and I mean the entire
range) using framebuffer in console (there probably is an emulator for
that job already, I have to check), but for the time being that's
enough.

    I really don't mind if I have to use an userspace program to have
unicode support on the console (the kernel shouldn't mess with
encodings, or have utf-8 only; I don't know the current status, that's
why I asked), but if the kernel does directly the job in the console
driver, that's not bad either.

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
