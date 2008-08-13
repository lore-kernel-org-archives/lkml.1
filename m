Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbYHMOqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbYHMOqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 10:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbYHMOpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 10:45:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50515 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbYHMOpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 10:45:50 -0400
Date: Wed, 13 Aug 2008 10:45:48 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kenneth Goldman <kgoldman@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/4] integrity: TPM internel kernel interface
Message-ID: <20080813144548.GA9157@infradead.org>
References: <20080812223636.1aff373a@lxorguk.ukuu.org.uk> <OFC8FDDFED.7F31F3B8-ON852574A4.004A3882-852574A4.004BA8FA@us.ibm.com> <20080813144040.30d40ec5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813144040.30d40ec5@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 02:40:40PM +0100, Alan Cox wrote:
> > "goodies", the TCG technology does not protect against hardware
> > attacks such as replacing the TPM with a bogus device, replacing the
> > CRTM hardware, flashing the CRTM using a JTAG cable, lifting a TPM pin>
> > and asserting reset, using a JTAG cable to set breakpoints and alter
> > memory, etc.
> > 
> > For this use case, the attack model is a remote, software attack.  The>
> > user is not considered the attacker.
> 
> Surely if I can replace your TPM with alternative hardware then I can
> also replace it with virtualised software traps.

Yes, which in fact is what most people working on TPM support use
because the real hardware is just too slow :)

> [If there is a good document on this btw please just point me there
> instead and I'll go read further]

I recommend this one:
http://www.few.vu.nl/~srijith/publications/confs/sws07-final.pdf  :)

