Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbZDWGDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbZDWGDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 02:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbZDWGDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 02:03:07 -0400
Received: from hope.ime.usp.br ([143.107.45.8]:44381 "HELO hope.ime.usp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751382AbZDWGDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 02:03:06 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Apr 2009 02:03:05 EDT
Date: Thu, 23 Apr 2009 02:56:19 -0300
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Michael Tokarev <mjt@tls.msk.ru>, Mark Lord <lkml@rtr.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: Quick question about libata and hdparm
Message-ID: <20090423055618.GA23042@ime.usp.br>
References: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br> <20090420221955.2c71bd26@lxorguk.ukuu.org.uk> <20090421053258.GA18001@ime.usp.br> <200904211459.26965.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200904211459.26965.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Bart, Alan.

On Apr 21 2009, Bartlomiej Zolnierkiewicz wrote:
> Incremental patch (a certain theory to verify).
(...)
> +	/* FIXME: this thrashes internal UDMA timings previously set by
> +	   controller on SET FEATURES - XFER MODE command "snooping" */
>  	/* The DMA clocks may have been trashed by a reset. FIXME: make conditional
>  	   and move to qc_issue ? */
> -	pdc202xx_set_dmamode(ap, qc->dev);
> +	/* pdc202xx_set_dmamode(ap, qc->dev); */

This didn't work. I still get those same messages. If you want, I can try
compiling the 2.6.30-rc3 kernel that was released now (as I mentioned
before, I was using 2.6.29).

I can test whatever you want me to.


Thanks,

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
