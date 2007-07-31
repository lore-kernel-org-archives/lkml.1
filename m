Return-Path: <linux-kernel-owner+w=401wt.eu-S1761279AbXGaOQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761279AbXGaOQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756727AbXGaOQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:16:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57496 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbXGaOQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:16:39 -0400
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
From: Arjan van de Ven <arjan@infradead.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, edwintorok@gmail.com, axboe@kernel.dk
In-Reply-To: <46AED656.8070407@gmail.com>
References: <20070705194909.337398431@intel.com>
	 <20070705130518.135e4e3c.kristen.c.accardi@intel.com>
	 <46AE12B6.6090408@garzik.org>  <46AED656.8070407@gmail.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 31 Jul 2007 07:16:22 -0700
Message-Id: <1185891382.2750.8.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 15:27 +0900, Tejun Heo wrote:
> Jeff Garzik wrote:
> > Any chance the SCSI peeps could ACK this, and then let me include it in
> > the ALPM patchset in the libata tree?
> 
> ATA link PS is pretty complex with HIPM, DIPM and AHCI ALPM.  I'm not
> sure whether this three level knob would be sufficient. 

adding more levels later is easy.

>  It might be
> good enough if we're gonna develop extensive in-kernel black/white list
> specifying which method works on which combination but my gut tells me
> that it's best left to userland (probably in the form of per-notebook PS
> profile).

either sucks. AHCI ALPM ought to work if it's supported; it's what other
operating systems also use... 
> 
> Adding to the fun, there are quite a few broken devices out there which
> act weirdly when link PS actions are taken.

do you have any specific examples that act funny with the patch in
question here? (the patch tries to be careful, previous patches weren't
always so please test this patch before claiming the concept as a whole
is broken)
> 
> Also, I generally don't think AHCI ALPM is a good idea.  It doesn't have
> 'cool down' period before entering PS state

that's a chipset implementation decision.... not part of the
spec/technology per se.


