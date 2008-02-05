Return-Path: <linux-kernel-owner+w=401wt.eu-S1759002AbYBEAJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002AbYBEAJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 19:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758604AbYBEAJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 19:09:14 -0500
Received: from waste.org ([66.93.16.53]:54938 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757416AbYBEAJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 19:09:09 -0500
Subject: Re: Integration of SCST in the mainstream Linux kernel
From: Matt Mackall <mpm@selenic.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Vladislav Bolkhovitin <vst@vlnb.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Christie <michaelc@cs.wisc.edu>
In-Reply-To: <20080204224314.113afe7b@core>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <47A05CBD.5050803@vlnb.net> <47A7049A.9000105@vlnb.net>
	 <1202139015.3096.5.camel@localhost.localdomain> <47A73C86.3060604@vlnb.net>
	 <1202144767.3096.38.camel@localhost.localdomain>
	 <47A7488B.4080000@vlnb.net>
	 <1202145901.3096.49.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>
	 <1202151989.11265.576.camel@haakon2.linux-iscsi.org>
	 <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
	 <20080204224314.113afe7b@core>
Content-Type: text/plain
Date: Mon, 04 Feb 2008 18:07:40 -0600
Message-Id: <1202170060.17934.142.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-04 at 22:43 +0000, Alan Cox wrote:
> > better. So for example, I personally suspect that ATA-over-ethernet is way 
> > better than some crazy SCSI-over-TCP crap, but I'm biased for simple and 
> > low-level, and against those crazy SCSI people to begin with.
> 
> Current ATAoE isn't. It can't support NCQ. A variant that did NCQ and IP
> would probably trash iSCSI for latency if nothing else.

But ATAoE is boring because it's not IP. Which means no routing,
firewalls, tunnels, congestion control, etc.

NBD and iSCSI (for all its hideous growths) can take advantage of these
things.

-- 
Mathematics is the supreme nostalgia of our time.

