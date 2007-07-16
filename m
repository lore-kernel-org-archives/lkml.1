Return-Path: <linux-kernel-owner+w=401wt.eu-S1762137AbXGPNad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762137AbXGPNad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 09:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbXGPNa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 09:30:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59540 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbXGPNaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 09:30:25 -0400
Date: Mon, 16 Jul 2007 15:29:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Olaf Kirch <olaf.kirch@oracle.com>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070716132958.GA8635@elte.hu>
References: <20070716091236.GA10718@elte.hu> <20070716.042640.18306462.davem@davemloft.net> <200707161418.42852.olaf.kirch@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707161418.42852.olaf.kirch@oracle.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Olaf Kirch <olaf.kirch@oracle.com> wrote:

> On Monday 16 July 2007 13:26, David Miller wrote:
> > Well, let's figure out why before we revert because it
> > is attempting to fix a legitimate bug.
> > 
> > Olaf, any ideas?
> 
> It seems as if the card is stuck in NAPI mode without being serviced 
> by net_rx_action.
> 
> Ingo, is this a UP or SMP machine? Are you still getting output from 
> netconsole, or is the network down completely?

there is some netconsole output but that too gets stuck after the tx 
timeout message. The e1000 options are:

CONFIG_E1000=y
CONFIG_E1000_NAPI=y
# CONFIG_E1000_DISABLE_PACKET_SPLIT is not set

	Ingo
