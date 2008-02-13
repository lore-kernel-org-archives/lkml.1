Return-Path: <linux-kernel-owner+w=401wt.eu-S932722AbYBMJ0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722AbYBMJ0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932526AbYBMJZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:25:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38568 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932507AbYBMJZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:25:05 -0500
Date: Wed, 13 Feb 2008 10:24:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <htejun@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Lord <mlord@pobox.com>, Jeff Garzik <jeff@garzik.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [libata-dev #upstream-fixes] pata_legacy: don't call
	ata_host_detach() after initialization failure
Message-ID: <20080213092430.GA25258@elte.hu>
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org> <20080212081816.GA17820@elte.hu> <20080212071452.5c58ae6d@laptopd505.fenrus.org> <20080213090159.GA21614@elte.hu> <47B2B653.7020408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B2B653.7020408@gmail.com>
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


* Tejun Heo <htejun@gmail.com> wrote:

> ata_host_detach() detaches an attached port and shouldn't be called on 
> a port which hasn't been attached yet.  pata_legacy incorrectly calls 
> ata_host_detach() on unattached port after initialization failure 
> causing oops.  Fix it.

thanks, i'll try this!

	Ingo
