Return-Path: <linux-kernel-owner+w=401wt.eu-S1750988AbXCBSVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750988AbXCBSVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 13:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbXCBSVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 13:21:15 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51482 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750987AbXCBSVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 13:21:14 -0500
Date: Fri, 2 Mar 2007 19:24:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alistair John Strachan <s0348365@sms.ed.ac.uk>
Cc: jgarzik@pobox.com, akpm@osdl.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata Kconfig: Update the various experimentality
 levels
Message-ID: <20070302192459.61ba13bb@lxorguk.ukuu.org.uk>
In-Reply-To: <200703021532.02215.s0348365@sms.ed.ac.uk>
References: <20070302150512.281af8d3@lxorguk.ukuu.org.uk>
	<200703021532.02215.s0348365@sms.ed.ac.uk>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007 15:32:01 +0000
Alistair John Strachan <s0348365@sms.ed.ac.uk> wrote:

> On Friday 02 March 2007 15:05, you wrote:
> > Signed-off-by: Alan Cox <alan@redhat.com>
> [snip]
> >  config PATA_OLDPIIX
> > -	tristate "Intel PATA old PIIX support (Experimental)"
> > +	tristate "Intel PATA support for the original PIIX"
> >  	depends on PCI && EXPERIMENTAL
> >  	help
> > -	  This option enables support for old(?) PIIX PATA support.
> > +	  This option enables support for early Intel PIIX PATA support.
> 
> Probably nothing, but is it intentional to remove the "(Experimental)" text 
> here, but not the dependency on EXPERIMENTAL?

Nope - I'll send a follow up patch to correct that later.

Thanks for checking the patches over

Alan
