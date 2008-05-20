Return-Path: <linux-kernel-owner+w=401wt.eu-S934605AbYETWro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934605AbYETWro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbYETWr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:47:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761346AbYETWr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:47:26 -0400
From: Andreas Schwab <schwab@suse.de>
To: Trent Piepho <tpiepho@freescale.com>
Cc: linuxppc-dev@ozlabs.org, Scott Wood <scottwood@freescale.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] Improve (in|out)_beXX() asm code
References: <1211316025-29069-1-git-send-email-tpiepho@freescale.com>
	<jeiqx83ab0.fsf@sykes.suse.de>
	<Pine.LNX.4.64.0805201502000.7453@t2.domain.actdsltmp>
X-Yow: I'd like TRAINED SEALS and a CONVERTIBLE on my doorstep by NOON!!
Date: Wed, 21 May 2008 00:47:23 +0200
In-Reply-To: <Pine.LNX.4.64.0805201502000.7453@t2.domain.actdsltmp> (Trent
	Piepho's message of "Tue, 20 May 2008 15:11:02 -0700 (PDT)")
Message-ID: <jeabik385g.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trent Piepho <tpiepho@freescale.com> writes:

> It's the _le versions that have a problem, since we can't get gcc to just use
> the register indexed mode.  It seems like an obvious thing to have a
> constraint for, but I guess there weren't enough instructions that only come
> in 'x' versions to bother with it.  There is a 'Z' constraint, "Memory operand
> that is an indexed or indirect from a register", but I tried it and it can use
> both "rb,ri" and "disp(rb)" forms.  Actually, I'm not sure how 'Z' is any
> different than "m"?

'Z' will never emit a non-zero constant displacement.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
