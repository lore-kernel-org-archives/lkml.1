Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbZBISq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbZBISq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 13:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbZBISqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 13:46:48 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:52853 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbZBISqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 13:46:47 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.40.92
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19CaBfhsAr+8KZI+aDSUFio
Date: Mon, 9 Feb 2009 10:46:38 -0800
From: Tony Lindgren <tony@atomide.com>
To: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Pierre Ossman <drzeus@drzeus.dddcx>, Jean Pihet <jpihet@mvista.com>,
       Paul Walmsley <paul@pwsan.com>,
       " Hunter Adrian (EXT-Teleca/Helsinki)" <ext-adrian.hunter@nokia.com>,
       OMAP <linux-omap@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       " linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH] OMAP: MMC: recover from transfer failures - Resend
Message-ID: <20090209184636.GG14200@atomide.com>
References: <20090206145343.2b8a5353@mjolnir.drzeus.cx> <20090209175851.GA30769@angel.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209175851.GA30769@angel.research.nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jarkko Lavinen <jarkko.lavinen@nokia.com> [090209 10:06]:
> Pierre Ossman wrote:
> > Related, who is the maintainer of this driver? Tony? I'd like
> > to have someone who checks patches before I queue them up.
> 
> I can be.  Tony asked me a month ago to set up git tree for OMAP
> HSMMC and put the workaround for the HSMMC multi-block DMA read
> corruption there, but hate to admit things have been hanging on
> todo list.

Yeah it would be great if Jarkkko can queue up all the omap MMC
patches from now on.

> There are some other fixes waiting. Omap_mmc_set_ios() doesn't
> handle power off case correctly and resume from suspend can hang
> if the SDBP bit fails to set.

And then all your PM patches for the next merge window..

Tony
