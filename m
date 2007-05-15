Return-Path: <linux-kernel-owner+w=401wt.eu-S934405AbXEOL1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934405AbXEOL1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 07:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934299AbXEOL1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 07:27:08 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52602 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934275AbXEOL1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 07:27:06 -0400
Date: Tue, 15 May 2007 12:31:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Kuther <gimpel@sonnenkinder.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: IT821x: no DMA since 2.6.21
Message-ID: <20070515123132.2e596d69@the-village.bc.nu>
In-Reply-To: <20070515125308.3a9f6442@SiRiUS.home>
References: <20070515125308.3a9f6442@SiRiUS.home>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 12:53:08 +0200
Thomas Kuther <gimpel@sonnenkinder.org> wrote:

> Hi!
> 
> Since 2.6.21 I have a problem with the it821x driver on my ITE 8212
> controller.
> Now I saw some updates to it821x in 2.6.22-rc1 and gave that a try, but
> the problem persists.

I've had multiple reports of this. I would recommend you use the libata
driver. IT821x hasn't changed over the past few releases so its someting
in the core IDE code that broke it [note it might not of course be that
the problem is in the core code..].

I have no plans at this point to debug the old IT821x driver due to time
constraints, and if anyone wants to have a crack at debugging this and
fixing it go for it.

BTW: I also note you have the controller in smart mode but are not using
the hardware raid functions. In that situation it generally runs faster
(and does CD-ROM) if you flash the ATAPI firmware to the controller or
boot with the noraid option "it8212.noraid=1"

Alan
