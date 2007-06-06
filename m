Return-Path: <linux-kernel-owner+w=401wt.eu-S934241AbXFFAvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934241AbXFFAvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 20:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933190AbXFFAvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 20:51:24 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:47819 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758215AbXFFAvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 20:51:22 -0400
Date: Wed, 6 Jun 2007 09:50:10 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Greg KH <greg@kroah.com>,
       "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>,
       Tom Long Nguyen <tom.l.nguyen@intel.com>, linux-ide@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Alan Cox <alan@redhat.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       "Horst H. von Brand" <vonbrand@inf.utfsm.cl>
Subject: Re: [2/2] 2.6.22-rc4: known regressions with patches
Message-ID: <20070606005010.GA8110@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-pci@atrey.karlin.mff.cuni.cz, Greg KH <greg@kroah.com>,
	"Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>,
	Tom Long Nguyen <tom.l.nguyen@intel.com>, linux-ide@vger.kernel.org,
	Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
	Alan Cox <alan@redhat.com>, sparclinux@vger.kernel.org,
	David Miller <davem@davemloft.net>,
	"Horst H. von Brand" <vonbrand@inf.utfsm.cl>
References: <46657866.7000108@googlemail.com> <4665792B.8030005@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4665792B.8030005@googlemail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 04:54:35PM +0200, Michal Piotrowski wrote:
> SATA/PATA
> 
> Subject    : libata reset-seq merge broke sata_sil on sh
> References : http://lkml.org/lkml/2007/5/10/63
> Submitter  : Paul Mundt <lethal@linux-sh.org>
> Handled-By : Tejun Heo <htejun@gmail.com>
> Caused-By  : commit 4750def52cb2c21732dda9aa1d43a07db37b0186
> Patch      : http://lkml.org/lkml/2007/5/19/161
> Status     : patch available
> 
Fixed by fd7fe701612e42fb8780d7bf61fbb0467a488c9b, which was already in
-rc3.
