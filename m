Return-Path: <linux-kernel-owner+w=401wt.eu-S1753627AbZBQQcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbZBQQcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 11:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbZBQQc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 11:32:27 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:41876 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751241AbZBQQc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 11:32:26 -0500
Date: Tue, 17 Feb 2009 16:31:21 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Pierre Ossman <drzeus-sdhci@drzeus.cx>, Ben Dooks <ben-linux@fluff.org>,
       Arnd Bergmann <arnd@arndb.de>, Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH RFC 0/13] FSL eSDHC support
Message-ID: <20090217163121.GA15020@fluff.org.uk>
References: <20090213144630.GA13436@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213144630.GA13436@oksana.dev.rtsoft.ru>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 05:46:30PM +0300, Anton Vorontsov wrote:
> Hi all,
> 
> Thanks for the comments on the previous version, here comes another
> RFC...
> 
> Changes since the second RFC:
> - Addressed all comments that were raised by Pierre Ossman.
>   There were too many to mention them all, so here is the link:
>   http://lkml.org/lkml/2009/2/6/320
> 
> Changes since the first RFC:
> - Use of_iomap() in sdhci-of.c (suggested by Arnd Bergmann). Also added
>   Arnd's Acked-by: line for the sdhci-of patch.
> - Kconfig help text improved (thanks to Matt Sealey and M. Warner Losh).
> - In "sdhci: Add quirk to suppress PIO interrupts during DMA transfers"
>   patch: sdhci_init() now clears SDHCI_PIO_DISABLED flag, otherwise we
>   won't disable PIO interrupts after suspend.
> - New patch: "sdhci: Add type checking for IO memory accessors"

It would be useful to know what Pierre thinks of these, I would like
to update the sdhci-s3c binding before the next merge window.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
