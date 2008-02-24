Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbYBXQuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbYBXQuE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 11:50:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbYBXQtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 11:49:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60971 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbYBXQtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 11:49:52 -0500
Date: Sun, 24 Feb 2008 17:49:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Priit Laes <plaes@plaes.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: fix build on non-C locales.
Message-ID: <20080224164938.GA2501@elte.hu>
References: <1203807950.12128.4.camel@localhost> <20080224090324.GA8169@uranus.ravnborg.org> <1203870965.17891.16.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203870965.17891.16.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Priit Laes <plaes@plaes.org> wrote:

>  sed-vdsosym := -e 's/^00*/0/' \
> -       -e 's/^\([0-9a-fA-F]*\) . \(VDSO[a-zA-Z0-9_]*\)$$/\2 = 0x\1;/p'
> +       -e 's/^\([[:xdigit:]]*\) . \(VDSO[[:alnum:]_]*\)$$/\2 = 0x\1;/p'

thanks, i picked up this one instead of the first version.

	Ingo
