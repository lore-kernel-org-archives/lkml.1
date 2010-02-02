Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab0BBVXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 16:23:11 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:51892 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756614Ab0BBVXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 16:23:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Wo7QzMawBqqu9UrtSEsl1zHveJQyXFGaSdjAo3g4l/jHWxlYQ4uDOMBBpLZR2bKnIR
         g3mzEwxgPg+BJI3THxFu/FY8fUMnhxvKvDLQfCdSVm20hy+FtS5YRe3/STdjF83F33DO
         aOHvTQd7t9m5+TQLx4Ipni/rWxmN7zzmGQ4DA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/2] move host drivers for VLB IDE controllers to staging/out
Date: Tue, 2 Feb 2010 22:22:29 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>
References: <20100202172701.7599.2028.sendpatchset@localhost> <20100202172708.7599.51937.sendpatchset@localhost> <20100202180041.3fe575f8@lxorguk.ukuu.org.uk>
In-Reply-To: <20100202180041.3fe575f8@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002022222.29728.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 February 2010 07:00:41 pm Alan Cox wrote:
> On Tue, 02 Feb 2010 18:27:08 +0100
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] move host drivers for VLB IDE controllers to staging/out
> > 
> > - they are for really old hardware that nobody has any longer
> > - they all require 'magic' parameters to work
> > - many controllers are also supported by pata_legacy driver
> > 
> > so move them to staging/out and schedule for removal in 2.6.36
> > unless somebody steps in to work on them.
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Acked-by: Alan Cox <alan@linux.intel.com>
> 
> When I actually tried some of the VLB bits while working on the
> pata_legacy stuff it was clear these hadn't been maintained/used for a
> very long time indeed. Most of them also are hacks doing stuff like fixed
> mode settings.
> 
> However if the point of the old IDE code was as claimed to keep it as a
> 'stable' layer throwing chunks of it out doesn't strike me as in keeping
> with the stated plan ...

I've always been under the impression that the claim was about adding new
stuff and not about removing dead code or ongoing efforts to make whole
kernel more maintainable.  Either way, Dave would be a much better person
to clarify it..

--
Bartlomiej Zolnierkiewicz
