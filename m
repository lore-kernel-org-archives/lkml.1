Return-Path: <linux-kernel-owner+w=401wt.eu-S1755005AbYBYI0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbYBYI0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 03:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbYBYI0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 03:26:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52716 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbYBYI0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 03:26:46 -0500
Date: Mon, 25 Feb 2008 09:26:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de
Subject: Re: [BUG] 2.6.25-rc2-git8 fails to boot on 486 due to TSC breakage
Message-ID: <20080225082634.GB12715@elte.hu>
References: <200802241107.m1OB7bHb022801@harpo.it.uu.se> <20080224135720.GA5323@elte.hu> <18369.35401.678391.183329@harpo.it.uu.se> <18369.43239.964660.62249@harpo.it.uu.se> <47C21284.7040607@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C21284.7040607@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Please fix it in both places.  Using XOR instead of AND-NOT is a bug, 
> plain and simple.

yes, i already fixed that when i added Mikael's patch and it's all 
queued up.

	Ingo
