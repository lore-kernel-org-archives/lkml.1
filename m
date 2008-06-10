Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbYFJTP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbYFJTP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 15:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbYFJTPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 15:15:46 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:26336 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbYFJTPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 15:15:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=BPBSysPLEy6tYGjj9ulVXh9ew6ej4wgL/5KHVoKiego69V2gYI8uzOUx4mz9pTBvjc
         uPZAjT5+Y8No8xF02cBoRQattsP6jVRZCJBrVt6I/RMXF/BtNKOkPAZ/zA1HbUohndAd
         lMR7eUVKC4lx+7vVhoxBu3xIf6Sfl4a6WHHC8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] swarm: use struct ide_port_info
Date: Tue, 10 Jun 2008 19:36:22 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200806082010.35429.bzolnier@gmail.com> <Pine.LNX.4.55.0806081934090.15673@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0806081934090.15673@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101936.23181.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 June 2008, Maciej W. Rozycki wrote:
> On Sun, 8 Jun 2008, Bartlomiej Zolnierkiewicz wrote:
> 
> > Convert the driver to use struct ide_port_info.
> > 
> > There should be no functional changes caused by this patch.
> > 
> > Cc: Maciej W. Rozycki <macro@linux-mips.org>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> 
> Acked-by: Maciej W. Rozycki <macro@linux-mips.org>
> 
>  Verified to work correctly on my system, thanks.

Thanks, I added Acked-by: + Tested-by: to the patch.

> > +	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
> 
>  You could have saved one <Tab> here. ;)

Well, yes but it matches other host drivers (which need two <Tab>s). :)

Bart
