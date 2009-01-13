Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbZAMMhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbZAMMhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 07:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbZAMMhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 07:37:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51103 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728AbZAMMhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 07:37:21 -0500
Date: Tue, 13 Jan 2009 13:37:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [tty bug] kernel BUG at drivers/char/tty_ldisc.c:359!
Message-ID: <20090113123717.GA30298@elte.hu>
References: <20090113121039.GA22155@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113121039.GA22155@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> FYI, -tip testing found a new warning in drivers/char/tty_ldisc.c:
> 
> [   37.725942] device: 'vcsa6': device_add
> [   37.725970] PM: Adding info for No Bus:vcsa6
> [   37.732059] ------------[ cut here ]------------
> [   37.732063] kernel BUG at drivers/char/tty_ldisc.c:359!
> [   37.732066] invalid opcode: 0000 [#1] SMP 

s/warning/crash

	Ingo
