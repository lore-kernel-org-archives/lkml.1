Return-Path: <linux-kernel-owner+w=401wt.eu-S1764522AbZEARMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764522AbZEARMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 13:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764100AbZEARKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 13:10:46 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:53238 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764199AbZEARKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 13:10:43 -0400
Date: Fri, 1 May 2009 19:10:42 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Christopher Sylvain <chris.sylvain@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: additional info for kernel-parameters.txt
In-Reply-To: <c4cb03b00904231631k49902d45o9ba6bad7e4b21094@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.0905011909440.7409@fbirervta.pbzchgretzou.qr>
References: <c4cb03b00904231631k49902d45o9ba6bad7e4b21094@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Cc: linux-kernel]

On Friday 2009-04-24 01:31, Christopher Sylvain wrote:

>a while ago you invited patches to kernel-parameters.txt when someone said
>they were
>unhappy with a reference to a source file instead of listing the actual
>parameters.

[1] possibly http://lkml.org/lkml/2006/12/18/185


>instead of a patch, how about simply adding:
>-----
>
>(We allow underscores for compatibility with the modules code)
>apm=on/off enable/disable APM
>[no-]allow[-_]ints allow interrupts during BIOS calls
>[no-]broken[-_]psr BIOS has a broken GetPowerStatus call
>[no-]realmode[-_]power[-_]off switch to real mode before powering off
>[no-]debug log some debugging messages
>[no-]power[-_]off power off on shutdown
>[no-]smp Use apm even on an SMP box
>bounce[-_]interval=<n> number of ticks to ignore suspend bounces
>idle[-_]threshold=<n> System idle percentage above which to make APM BIOS
>idle calls. Set it to 100 to disable.
>idle[-_]period=<n> Period (in 1/100s of a second) over which the idle
>percentage is calculated.
>
>see /linux/arch/x86/kernel/apm_32.c for some additional information

Saying "we allow underscores" is enough, I would not clutter the 
textfile with [-_].

>
>-----
>
>to the entry for [APM] ?
>
>
>

