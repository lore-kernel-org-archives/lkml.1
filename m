Return-Path: <linux-kernel-owner+w=401wt.eu-S1761489AbXGXTKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761489AbXGXTKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 15:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbXGXTKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 15:10:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51211 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbXGXTKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 15:10:35 -0400
Date: Tue, 24 Jul 2007 21:10:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: v2.6.22.1-rt5
Message-ID: <20070724191027.GA13268@elte.hu>
References: <20070724120436.GA14466@elte.hu> <200707241156.03149.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707241156.03149.gene.heskett@gmail.com>
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


* Gene Heskett <gene.heskett@gmail.com> wrote:

> The above stanza still needs some tlc.  I built a 2.6.22.1-rt6 (rt5 
> wouldn't build) using the same old config that a make oldconfig didn't 
> fuss about, but the reboot never completed, see the attached, heavily 
> smunched camera shot of the panic.
> 
> Kinda looks like hda/sda confusion, with rt3 (this boot), its hda*, 
> what is it now?  fstab or kernel config error?

yeah, as long as your filesystems are created with a proper label, all 
that you need to do is to change all 'hda' to 'sda' in the new kernel's 
/etc/grub.conf entry. (or enable the old IDE code in the .config, under 
CONFIG_IDE)

	Ingo
