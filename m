Return-Path: <linux-kernel-owner+w=401wt.eu-S1031809AbXFHU1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031809AbXFHU1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 16:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969573AbXFHU1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 16:27:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:48897 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969435AbXFHU1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 16:27:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=QHbw5GquHDmAk/ds9jQVvDJgO32lFi3eZt7ZAroA8N9kG0W8d/1FAZXktdHo2xmKXLJLwn7yRk/FE7B2//yinLe8ipAgERPxvZTdFx2TcSIMJmsrVo0mUING2zrkD9f4jl/0adp7dUgQPpcawoIXsOC62giDfMzNnDKrSjXU1Dw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/1] ide: ide-generic, add another device exception
Date: Fri, 8 Jun 2007 22:41:24 +0200
User-Agent: KMail/1.9.6
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Korb <ml@akana.de>, linux-ide@vger.kernel.org
References: <20601315171560711667@wsc.cz> <200706081418.56217.bzolnier@gmail.com> <20070608135931.GB24346@havoc.gtf.org>
In-Reply-To: <20070608135931.GB24346@havoc.gtf.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706082241.24233.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday 08 June 2007, Jeff Garzik wrote:
> On Fri, Jun 08, 2007 at 02:18:55PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Monday 04 June 2007, Jiri Slaby wrote:
> > > ide-generic, add another device exception
> > 
> > ide-generic is a generic ISA IDE driver, this one is drivers/ide/pci/generic
> > (a generic IDE PCI driver) - fixed patch description to avoid confusion.
> > 
> > [ Yes, both drivers need a rename - patches are welcomed. ]
> 
> Probably best to do a rename from your side, in git.

AFAIR git-quiltimport of quilt patches should handle this just fine?

My previous description of the issue was a bit too cryptic: besides
changing ide/ide-generic.c and ide/pci/generic.c filenames, ide/Kconfig
(names of config options) and ide/Makefile should be updated accordingly.
Also enhancing Kconfig entries for both drivers to be more verbose would
be more than appropriate.

Since I'm quite time constrained and I'm working on other IDE issues I
would prefer that somebody else handle this task and just send me patches.

8)

Thanks,
Bart
