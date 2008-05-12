Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbYELVpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbYELVpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 17:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbYELVpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 17:45:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:44378 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbYELVpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 17:45:44 -0400
From: Andreas Schwab <schwab@suse.de>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>, Matthew Wilcox <matthew@wil.cx>,
       ARCH <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: [PATCHv2] Make for_each_cpu_mask a bit smaller
References: <20080511135039.GA3286@mailshack.com>
	<20080511091403.a75f5b78.pj@sgi.com>
	<20080511160658.GA3398@mailshack.com>
	<20080511160104.c3fef6bf.pj@sgi.com>
	<1210593896.23716.1252664185@webmail.messagingengine.com>
	<4828741B.2080802@sgi.com> <20080512190039.GA13324@mailshack.com>
X-Yow: My face is new, my license is expired, and I'm under a doctor's care!!!!
Date: Mon, 12 May 2008 23:45:42 +0200
In-Reply-To: <20080512190039.GA13324@mailshack.com> (Alexander van Heukelum's
	message of "Mon, 12 May 2008 21:00:39 +0200")
Message-ID: <jeej8742nt.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum <heukelum@mailshack.com> writes:

> +#define for_each_cpu_mask(cpu, mask)			\
> +	for ((cpu) = ~((typeof(cpu))0);			\

There is no need for such a complicated expression, -1 will work for
every (arithmetic) type.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
