Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbXIDJjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbXIDJjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 05:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbXIDJjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 05:39:42 -0400
Received: from john.hrz.tu-chemnitz.de ([134.109.132.2]:42465 "EHLO
	john.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbXIDJjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 05:39:41 -0400
Date: Tue, 4 Sep 2007 11:39:39 +0200
From: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
To: Mark Hindley <mark@hindley.org.uk>
Cc: Satyam Sharma <satyam@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Netdev Mailing List <netdev@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH -mm 1/2] 3c59x: Fix uninitialized variable bug
Message-ID: <20070904093939.GD4241@newton.mathematik.tu-chemnitz.de>
References: <alpine.LFD.0.999.0709040340250.8504@enigma.security.iitk.ac.in> <20070904081602.GB4241@newton.mathematik.tu-chemnitz.de> <20070904085331.GH5944@hindley.org.uk> <20070904093510.GL5944@hindley.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070904093510.GL5944@hindley.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.3 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: f69c3b77c4b3e26dd0b52dac0e0ea9f8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2007 at 10:35:10AM +0100, Mark Hindley wrote:
> On Tue, Sep 04, 2007 at 11:17:57AM +0200, Steffen Klassert wrote:
>  
> > The only warning that I was able to trigger with gcc 4.2 is in the case of a .config
> > without PCI support. In this case I get
> > 
> > drivers/net/3c59x.c: In function 'vortex_up':
> > drivers/net/3c59x.c:1672: warning: 'err' is used uninitialized in this function
> 
> That should be fixed by Satyam's patch too.

Yes, of course.
This was just to point out what's  possible to trigger with a newer gcc and what's not.

Steffen
