Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908Ab0AJU32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab0AJU32 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 15:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890Ab0AJU31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 15:29:27 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:57331 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab0AJU30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 15:29:26 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
To: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Cc: Tim Abbott <tabbott@ksplice.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: "m68k: Cleanup linker scripts using new linker script macros." and old binutils (was: Re: [PATCH] m68k: Atari EtherNAT - Nicolas Pitre has a new email address)
References: <10f740e81001100128q644cae1eg61c12b64f22e8398@mail.gmail.com>
	<alpine.DEB.1.10.1001101100540.1326@dr-wily.mit.edu>
	<alpine.DEB.2.00.1001102020420.19754@zirkon.biophys.uni-duesseldorf.de>
X-Yow: HERE!!  Put THIS on!!  I'm in CHARGE!!
Date: Sun, 10 Jan 2010 21:29:23 +0100
In-Reply-To: <alpine.DEB.2.00.1001102020420.19754@zirkon.biophys.uni-duesseldorf.de>
	(Michael Schmitz's message of "Sun, 10 Jan 2010 21:12:59 +0100 (CET)")
Message-ID: <m21vhxln4s.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Schmitz <schmitz@biophys.uni-duesseldorf.de> writes:

> And indeed, the old script places the init task data between .init_end and _end.

This is exactly your problem.  The bootloader puts the bootinfo
structure at _end, and the kernel reads it from there.  But in your
non-working kernel that overlaps the init task structure.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
