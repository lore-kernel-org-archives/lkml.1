Return-Path: <linux-kernel-owner+w=401wt.eu-S1760837AbZCaTcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760837AbZCaTcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 15:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbZCaTbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 15:31:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55869 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbZCaTbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 15:31:51 -0400
From: Gabor Kovacs <kgabor@bolyai.elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] parport: Use the PCI IRQ if offered
Date: Tue, 31 Mar 2009 15:31:56 -0400
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; x86_64; ; )
References: <20090326205558.5686.36265.stgit@localhost.localdomain> <49CC046A.7040209@garzik.org>
In-Reply-To: <49CC046A.7040209@garzik.org>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903311531.56965.kgabor@bolyai.elte.hu>
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

just to confirm, IRQ detection works fine on my Lava parallel card. 

The instrument driver module that registers an irq handler via 
parport_register_device gets false events when parport irq is shared e.g. with 
an ethernet controller. Should irq sharing awareness go to our handler 
function or parport_irq_handler/parport_generic_irq still needs some 
additional patch? (Or have I just missed this second patch?)

Thanks

Gabor Kovacs


On Thursday 26 March 2009 18:40:42 Jeff Garzik wrote:
> Alan Cox wrote:
> > Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
>
> Reviewed-by: Jeff Garzik <jgarzik@redhat.com>
>
> A long, long time ago I poked at introducing some PCI-ish probing to
> parport_pc, reading the port mode, I/O port, and possibly irq from
> motherboard-specific magic locations.
>
> This is a helpful extension of that [years-old] work... good stuff.
>
> 	Jeff
>
>
>


