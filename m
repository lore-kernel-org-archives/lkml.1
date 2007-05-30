Return-Path: <linux-kernel-owner+w=401wt.eu-S1752241AbXE3IXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbXE3IXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbXE3IXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:23:48 -0400
Received: from ns2.suse.de ([195.135.220.15]:58812 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbXE3IXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:23:46 -0400
From: Andreas Schwab <schwab@suse.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 1/2] m68k: runtime patching infrastructure
References: <20070528191630.377693320@mail.of.borg>
	<20070528191715.352919509@mail.of.borg>
	<20070529173818.fd94ae81.akpm@linux-foundation.org>
	<465D1020.3030605@cosmosbay.com>
	<Pine.LNX.4.64.0705300903030.31930@anakin>
X-Yow: Are you still an ALCOHOLIC?
Date: Wed, 30 May 2007 10:23:36 +0200
In-Reply-To: <Pine.LNX.4.64.0705300903030.31930@anakin> (Geert Uytterhoeven's
	message of "Wed\, 30 May 2007 09\:06\:08 +0200 \(CEST\)")
Message-ID: <jefy5e1zzr.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> I was puzzled by this as well, as there were no compiler warnings...
>
> Apparently you get a warning only if the _first_ occurrence of a struct
> is declared inside a parameter list of a function.

The parameter list has its own scope.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
