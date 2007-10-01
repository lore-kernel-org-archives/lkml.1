Return-Path: <linux-kernel-owner+w=401wt.eu-S1757744AbXJCILq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744AbXJCILq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 04:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbXJCILc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 04:11:32 -0400
Received: from n2.bullet.mail.mud.yahoo.com ([209.191.127.222]:44609 "HELO
	n2.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752625AbXJCILb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 04:11:31 -0400
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Oct 2007 04:11:29 EDT
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 831721.29682.bm@omp105.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=yH0p7Xa53FkejCSpJUeKL3g42t+2nG6tFElL5c8IsJMCXKsUovDpNTAKrCBNXC0yQJcFnShPZtB54q0NbKDYVn9UETirap+cTUSZ5peNoLjY0VR2jBPS0OzvA/N6g/32sOgKmlZLWFqzSRznRagVWnKBkMozHAeKJAPzYOg1Rd8=;
X-YMail-OSG: .bDNJ.cVM1nCsqTQWPXUQNTfz8Q0objiHDXBlBFh1kqOdT6YeEiXu6JJIK0gLRMBwg--
Date: Mon, 1 Oct 2007 11:51:21 +0100 (BST)
From: veerasena reddy <veerasena_b@yahoo.co.in>
Subject: Re: linux cache routines for Write-back cache policy on  MIPS24KE
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-mips <linux-mips@linux-mips.org>,
       "linux-kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0710011121300.20679@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <302271.86305.qm@web8404.mail.in.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Thanks for your repsonse.

In linux-2.6.18 (for MIPS24KE processor):
suppose if i want to do flush only then which API i
should use?
Similarly, if i want to do invalidation only which API
i should use?

Thanks again.

Regards,
Veerasena.
--- Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Mon, 1 Oct 2007, veerasena reddy wrote:
> > I have ported Linux-2.6.18 kernel on MIPS24KE
> > processor. I am using write back cache policy.
> > 
> > Could you please guide me under what cases the
> below
> > cache API's are being used:
> > - dma_cache_wback_inv() : Could you explain  what
> > exactly this function does
> 
> It does both write back and invalidate.
> 
> > - dma_cache_wback() : This function write back the
> > cache data to memory
> > - dma_cache_inv  : This function invalidate the
> cache
> > tags. so subsequent access will fetch from memory.
> 
> Note that 2.6.18 is old. The above functions are
> intended to be removed.
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



      Get the freedom to save as many mails as you wish. To know how, go to http://help.yahoo.com/l/in/yahoo/mail/yahoomail/tools/tools-08.html

