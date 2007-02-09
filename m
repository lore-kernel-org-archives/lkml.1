Return-Path: <linux-kernel-owner+w=401wt.eu-S1422738AbXBIAGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422738AbXBIAGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 19:06:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422759AbXBIAGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 19:06:47 -0500
Received: from ns2.suse.de ([195.135.220.15]:40413 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422738AbXBIAGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 19:06:46 -0500
From: Andreas Schwab <schwab@suse.de>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Oleg Verych <olecom@flower.upol.cz>
Subject: Re: The who needs reviews anyways [PATCH]
References: <Pine.LNX.4.64.0702082227020.14457@scrub.home>
X-Yow: Yow!  Am I having fun yet?
Date: Fri, 09 Feb 2007 01:06:39 +0100
In-Reply-To: <Pine.LNX.4.64.0702082227020.14457@scrub.home> (Roman Zippel's
	message of "Thu, 8 Feb 2007 22:48:51 +0100 (CET)")
Message-ID: <jey7n8urcg.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Zippel <zippel@linux-m68k.org> writes:

> - printf has other side effects, instead stop pretending we support 
>   something else than bash

printf is a much better echo, but you need to use it properly as well.
Either use %s to print a literal string or %b to let it interpret escape
sequences.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
