Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbYBYRB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbYBYRB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 12:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbYBYRBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 12:01:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33440 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbYBYRBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 12:01:48 -0500
Date: Mon, 25 Feb 2008 18:01:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@mailshack.com>
Subject: Re: [PATCH] Fix alignment of early reservation for EBDA
Message-ID: <20080225170134.GA15839@elte.hu>
References: <20080224174605.GA21661@mailshack.com> <47C22568.1010405@zytor.com> <1203958478.20033.1239002461@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203958478.20033.1239002461@webmail.messagingengine.com>
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


* Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> Then, how about reserving everything from the end of conventional 
> memory up to the 1Mb mark? Like this:

looks very good to me - could you send a patch against x86.git#testing?

	Ingo
