Return-Path: <linux-kernel-owner+w=401wt.eu-S1757183AbZCQWwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183AbZCQWwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 18:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757553AbZCQWwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 18:52:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47133 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756599AbZCQWwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 18:52:33 -0400
From: Gabor Kovacs <kgabor@bolyai.elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Lava dual parallel PCI card IRQ problem
Date: Tue, 17 Mar 2009 18:52:20 -0400
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200903130051.18119.kgabor@bolyai.elte.hu> <20090316105728.4380454c@lxorguk.ukuu.org.uk>
In-Reply-To: <20090316105728.4380454c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903171852.20408.kgabor@bolyai.elte.hu>
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

On Monday 16 March 2009 06:57:28 Alan Cox wrote:
> On Fri, 13 Mar 2009 00:51:18 -0400
>
> Gabor Kovacs <kgabor@bolyai.elte.hu> wrote:
> > Hi All,
> >
> > I have problems in setting up IRQ mode operation of parallel ports using
> > onboard port and a LAVA dual parallel PCI card. IRQ is needed to catch
> > events of an external instrument.
>
> The current driver never tries to initialise IRQ support for parallel PCI
> ports and never has. I am not sure why this should be the case but I can
> send you a patch to see what happens if we enable it.

Thanks, that would be great. Indeed, I also looked a bit into parport_pc.c and 
found that there is no autodetection. There is some irq detection code in 
irq_probe_EPP (disabled by ADVANCED_DETECT macro), but enabling it gives 
compile error.

Gabor

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

