Return-Path: <linux-kernel-owner+w=401wt.eu-S1757426AbXJCBn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbXJCBn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 21:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755547AbXJCBnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 21:43:50 -0400
Received: from n7.bullet.mud.yahoo.com ([216.252.100.58]:27083 "HELO
	n7.bullet.mud.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757083AbXJCBnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 21:43:49 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 507138.43162.bm@omp103.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=WJZfArM1nFJ48nLF8v7s7JncM0/nshX7nOj1MfLlSRPboVcdskjfnpLKx1l9iTlbaHa3hvZYYqobJrpQsCXCmCMsfc7saFoy+IiliwAYlylzH8DxwNkT+d6fYp+izB6zBGNyWDuL2NWyMZBSJzslKFapy/b0lJj6osrHjqS7rPE=;
X-YMail-OSG: seURp90VM1lCQ9NKSyRWx4lTNpcVIUWDCYzqjgtlf9Y62jSectMGExqe.Mdiqp3y2mDz8iIyApuLugd88KlDl_bJCgoLCGoRYI0ndEW9vBk3e0Us1Y6_dqpS0IbJXQ--
Date: Mon, 1 Oct 2007 13:13:47 +0100 (BST)
From: veerasena reddy <veerasena_b@yahoo.co.in>
Subject: Re: linux cache routines for Write-back cache policy on  MIPS24KE
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-mips <linux-mips@linux-mips.org>,
       "linux-kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0710011341320.20679@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <900355.95714.qm@web8402.mail.in.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi Geert,

here i mean 'flush' is 'write-back only'

Regards,
Veerasena.
--- Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Mon, 1 Oct 2007, veerasena reddy wrote:
> > In linux-2.6.18 (for MIPS24KE processor):
> > suppose if i want to do flush only then which API
> i
> > should use?
> 
> `flush' is fuzzy terminology: some people mean
> invalidate, others mean
> write back, others mean both.
> 
> > Similarly, if i want to do invalidation only which
> API
> > i should use?
> 
> dma_cache_inv().
> 
> > --- Geert Uytterhoeven <geert@linux-m68k.org>
> wrote:
> > 
> > > On Mon, 1 Oct 2007, veerasena reddy wrote:
> > > > I have ported Linux-2.6.18 kernel on MIPS24KE
> > > > processor. I am using write back cache policy.
> > > > 
> > > > Could you please guide me under what cases the
> > > below
> > > > cache API's are being used:
> > > > - dma_cache_wback_inv() : Could you explain 
> what
> > > > exactly this function does
> > > 
> > > It does both write back and invalidate.
> > > 
> > > > - dma_cache_wback() : This function write back
> the
> > > > cache data to memory
> > > > - dma_cache_inv  : This function invalidate
> the
> > > cache
> > > > tags. so subsequent access will fetch from
> memory.
> > > 
> > > Note that 2.6.18 is old. The above functions are
> > > intended to be removed.
> 
> Gr{oetje,eeting}s,
> 
> 						Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond
> ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I
> call myself a hacker. But
> when I'm talking to journalists I just say
> "programmer" or something like that.
> 							    -- Linus Torvalds
> 
> 



      Forgot the famous last words? Access your message archive online at http://in.messenger.yahoo.com/webmessengerpromo.php

