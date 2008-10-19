Return-Path: <linux-kernel-owner+w=401wt.eu-S1751500AbYJSMDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbYJSMDk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 08:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYJSMDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 08:03:31 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:53386 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbYJSMDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 08:03:30 -0400
Date: Sun, 19 Oct 2008 10:03:24 -0200
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>
Subject: Re: A small and silly question regarding libata
Message-ID: <20081019120324.GA3455@ime.usp.br>
References: <20081019031236.GB7887@ime.usp.br> <20081019112324.0c2fd36b@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081019112324.0c2fd36b@the-village.bc.nu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First of all, thank you very much Alan.

On Oct 19 2008, Alan Cox wrote:
> > hda: 156301488 sectors (80026 MB) w/2048KiB Cache, CHS=65535/16/63
> > - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> > 
> > What is the current status with libata for PATA devices?
> 
> You can choose to ignore it with libata.

Some clarification here: do you mean with ignore_hpa=1 here?

>From a quick reading of the code in libata-core.c, it seems that the
code tries to disable hpa, if possible. Is that correct?

I now regret having partitioned an HD under a 2.4 kernel. :-( I'm
wasting 10MiB according to bc. :-(

I wish that USB enclosures would also allow things like hpa to be
disabled.


Thank you very much for your help, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
