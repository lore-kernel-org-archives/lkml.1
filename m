Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbYFRIby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbYFRIby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 04:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbYFRIbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 04:31:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37870 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbYFRIbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 04:31:46 -0400
Date: Wed, 18 Jun 2008 10:31:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, Daniel.Rahn@novell.com,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [patch] correctly report NR_BANKS in mce_64.c
Message-ID: <20080618083133.GG4135@elte.hu>
References: <20080606074236.GA13151@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606074236.GA13151@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Pavel Machek <pavel@suse.cz> wrote:

> From: Daniel Rahn <Daniel.Rahn@novell.com>
> 
> attached is a no-brainer that makes kernel correctly report
> NR_BANKS for MCE. We are right now limited to NR_BANKS==6, but the
> error message will use the available number of banks instead of the
> defined maximum.
> 
> For a Nehalem based system it will print:
> 
> "MCE: warning: using only 9 banks"
> 
> while the correct message would be
> 
> "MCE: warning: using only 6 banks"
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>

applied to tip/x86/mce, thanks Pavel.

[ There was a recent crossing commit that made your patch not apply 
  cleanly (8edc5cc5ec8 from May 12), i fixed up the impact manually. ]

	Ingo
