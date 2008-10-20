Return-Path: <linux-kernel-owner+w=401wt.eu-S1752860AbYJTWBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbYJTWBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 18:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbYJTWBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 18:01:42 -0400
Received: from ns2.suse.de ([195.135.220.15]:46883 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbYJTWBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 18:01:41 -0400
From: Andreas Schwab <schwab@suse.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: discarded `.exit.text' debugging?
References: <Pine.LNX.4.64.0810202207140.23258@anakin>
X-Yow: Two with FLUFFO, hold th' BEETS..side of SOYETTES!
Date: Tue, 21 Oct 2008 00:01:39 +0200
In-Reply-To: <Pine.LNX.4.64.0810202207140.23258@anakin> (Geert Uytterhoeven's
	message of "Mon, 20 Oct 2008 22:09:11 +0200 (CEST)")
Message-ID: <je3airq62k.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> Last night I got these in my build logs:
>
> | `.exit.text' referenced in section `.init.text' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
> | `.exit.text' referenced in section `.data' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
>
> i.e. not much context. Is there an easy way to find out who's the
> offender?

You could try giving each .exit.text section a unique name per object
file (so that "ld -r" does not merge them) and modify EXIT_TEXT to
collect all those sections during the final link.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
