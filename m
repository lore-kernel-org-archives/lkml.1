Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbXD0Whc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbXD0Whc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 18:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757513AbXD0Whb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 18:37:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:28866 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757511AbXD0Wha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 18:37:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hswLBgZl3E6b8S0KLbdCwQAE796/Fi/ipNmJoB7A2NGebHaw3W0ok6eUURsbQ98JwKdF9zzqoTdp2OHtKwuwwZiTOUYYa3kdEIK8Ug9sxoH4C4vDv/tZwGBctAZjcbpxip7vKseX4Ft4sgmE57aEy4TYTa2Pt6nom0fI7wmwvJg=
Subject: Re: [linux-dvb] Re: More than 2Gb problem (dvb related) ?
From: Jon Burgess <jburgess777@googlemail.com>
To: Lee Revell <rlrevell@joe-job.com>
Cc: Markus Rechberger <mrechberger@gmail.com>,
       Gregoire Favre <Gregoire.Favre@gmail.com>, linux-dvb@linuxtv.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <75b66ecd0704271506x595dfb6bqe0ef4fd153818501@mail.gmail.com>
References: <20070427111047.GB10284@gmail.com>
	 <d9def9db0704271346i1556c59dgad222d5de7d919f6@mail.gmail.com>
	 <1177711220.26292.20.camel@localhost.localdomain>
	 <75b66ecd0704271506x595dfb6bqe0ef4fd153818501@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 23:37:26 +0100
Message-Id: <1177713446.7205.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 18:06 -0400, Lee Revell wrote:
> On 4/27/07, Jon Burgess <jburgess777@googlemail.com> wrote:
> > Interesting - I see similar symptoms after upgrading my PC:
> > * old PC was AMD Athlon 64 3000 w/ 2GB of RAM which had no issues
> > * new PC is a Intel Core 2 Duo w/ 4GB of RAM and fails in the way you
> > describe.
> 
> Driver using an incorrect DMA mask?
> 
> Lee

It does not set one explicitly and the docs suggest the default is
32bit. Adding an explicit "pci_set_dma_mask(dev->pci, DMA_24BIT_MASK)"
does not seem to make a difference. Mind you, the driver builds its own
S-G DMA table in saa7146_vmalloc_build_pgtable() and i'm not certain
whether this might bypass this setting.

	Jon




