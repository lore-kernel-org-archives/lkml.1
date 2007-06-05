Return-Path: <linux-kernel-owner+w=401wt.eu-S932993AbXFEP6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993AbXFEP6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932151AbXFEP5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 11:57:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53134 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180AbXFEP5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 11:57:50 -0400
From: Andreas Schwab <schwab@suse.de>
To: Richard Purdie <richard@openedhand.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problems (a bug?) with UINT_MAX from kernel.h
References: <1181054562.6180.77.camel@localhost.localdomain>
X-Yow: Dizzy, are we "REAL PEOPLE" or "AMAZING ANIMALS"?
Date: Tue, 05 Jun 2007 17:57:39 +0200
In-Reply-To: <1181054562.6180.77.camel@localhost.localdomain> (Richard
	Purdie's message of "Tue\, 05 Jun 2007 15\:42\:42 +0100")
Message-ID: <je7iqiqtqk.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Purdie <richard@openedhand.com> writes:

> If I try to compile the code fragment below, I see the error:
>
> #define UINT_MAX	(~0U)
> #if (0xffffffffffffffff == UINT_MAX)
>   #error argh
> #endif

The preprocessor computes all expressions with the largest available
range.  It does not know anything about types.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
