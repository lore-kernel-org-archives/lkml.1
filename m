Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbYEZQQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbYEZQQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 12:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYEZQQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 12:16:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45698 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbYEZQQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 12:16:21 -0400
Date: Mon, 26 May 2008 08:44:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Bug 10797] Something is consuming power after shutdown
Message-ID: <20080526084458.6acce426@infradead.org>
In-Reply-To: <483AB443.6020807@diamondcut.com.br>
References: <483AB443.6020807@diamondcut.com.br>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008 09:59:47 -0300
"Renato S. Yamane" <yamane@diamondcut.com.br> wrote:

> <http://bugzilla.kernel.org/show_bug.cgi?id=10797>
> <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=481493>
> 
> After poweroff, something still working and consuming power. So I
> loss ~4% of my battery charge in each 12h.
> 
> If I shutdown my laptop using Kernel 2.6.24/25 when battery is 100%, 
> after 12h my battery charge go to 96% (this information is checked
> with kpowersave and with LED available in my laptop that change color
> from blue to yellow when battery is not FULL).
> 
> If I shutdown this same laptop by WinXP (I have a dual boot), nothing 
> change. So, my battery still have 100% after 12h (or more).
> 
> I see a similar problem in EeePC (the problem is with snd_hda_intel 
> driver), but I don't have this driver loaded:


the most obvious cause could be Wake-on-Lan, that leaves a part of the
system active (specifically, the network card). With the "ethtool"
program you can queary and set the state of this.

Similarly, but less likely, there is wake-on-serial and wake-on-usb, in
theory those are possible too but I've yet to see one of those on any
of my machines.

