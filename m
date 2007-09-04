Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbXIDIQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbXIDIQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 04:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbXIDIQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 04:16:07 -0400
Received: from john.hrz.tu-chemnitz.de ([134.109.132.2]:59792 "EHLO
	john.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbXIDIQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 04:16:05 -0400
X-Greylist: delayed 1221 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Sep 2007 04:16:05 EDT
Date: Tue, 4 Sep 2007 10:16:02 +0200
From: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
To: Satyam Sharma <satyam@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Netdev Mailing List <netdev@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Mark Hindley <mark@hindley.org.uk>
Subject: Re: [PATCH -mm 1/2] 3c59x: Fix uninitialized variable bug
Message-ID: <20070904081602.GB4241@newton.mathematik.tu-chemnitz.de>
References: <alpine.LFD.0.999.0709040340250.8504@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709040340250.8504@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.3 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: 0e3fbd3f50959cf49c69ab43e98fd2b3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2007 at 03:45:55AM +0530, Satyam Sharma wrote:
> 
> drivers/net/3c59x.c: In function 'vortex_up':
> drivers/net/3c59x.c:1495: warning: 'err' may be used uninitialized in this function

This came in with the recently applied 3c59x-check-return-of-pci_enable_device patch
from Mark Hindley. I just compiled it on a PCI only machine so far, therefore I did
not notice the warning yet.

> 
> is a genuine bug. The function returns an uninitialized value of 'err'
> back to the caller, which expects it to be 0 for success cases. Let's
> fix this by explicitly initializing 'err' to zero.
> 
> Signed-off-by: Satyam Sharma <satyam@infradead.org>
Acked-by: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
