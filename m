Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbXD3PBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbXD3PBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbXD3PBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:01:16 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44446 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755339AbXD3PBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:01:15 -0400
Date: Mon, 30 Apr 2007 16:05:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Juergen Beisert <juergen127@kreuzholzen.de>
Cc: linux-kernel@vger.kernel.org, Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [PATCH] [1/1] CPU-i386-Geode: Chipset access macros do not work
 as expected
Message-ID: <20070430160508.25315f16@the-village.bc.nu>
In-Reply-To: <200704301509.58776.juergen127@kreuzholzen.de>
References: <200704301509.58776.juergen127@kreuzholzen.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007 15:09:58 +0200
Juergen Beisert <juergen127@kreuzholzen.de> wrote:

> From: Juergen Beisert <juergen.beisert@weihenstephan.org>
> 
> Replace NSC/Cyrix specific chipset access macros by inlined functions.
> With the macros a line like this fails (and does nothing):
> 	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
> With inlined functions this line will work as expected.
> 
> Note about a side effect: Seems on Geode GX1 based systems the
> "suspend on halt power saving feature" was never enabled due to this
> wrong macro expansion. With inlined functions it will be enabled, but
> this will stop the TSC when the CPU runs into a HLT instruction.
> Kernel output something like this:
> 	Clocksource tsc unstable (delta = -472746897 ns)
> Tested on a Geode GX1 system.
> 
> Signed-off-by: Juergen Beisert <juergen.beisert@weihenstephan.org>

Acked-by: Alan Cox <alan@redhat.com>
