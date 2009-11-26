Return-Path: <linux-kernel-owner+w=401wt.eu-S1760659AbZKZPlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760659AbZKZPlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 10:41:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755894AbZKZPla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 10:41:30 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47614 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbZKZPl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 10:41:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=c381vUmpX5xOy8wtQkRII3i19rv2BkhfyIJ68WecFKETK0QGNjkN4/LxhB3RbnJYqp
         6iQEcLhLonapzDgbFi99NIX7I4WK1MqKc/RBkg+wGK2v8FZQiPtvKFtSmOJFZJFbrhMb
         f6JyMElp6/Aff0ubVKB1W3g+lf7YGeGQq5+U4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 16/86] pata_efar: MWDMA0 is unsupported
Date: Thu, 26 Nov 2009 16:40:39 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <20091126151546.6c891014@lxorguk.ukuu.org.uk> <4B0E9FB9.8050508@ru.mvista.com>
In-Reply-To: <4B0E9FB9.8050508@ru.mvista.com>
MIME-Version: 1.0
Message-Id: <200911261640.39208.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 November 2009 04:33:13 pm Sergei Shtylyov wrote:
> Hello.
> 
> Alan Cox wrote:
> 
> >>On Wednesday 25 November 2009 06:25:52 pm Alan Cox wrote:
> 
> >>>On Wed, 25 Nov 2009 18:04:15 +0100
> >>>Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> >>>>From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >>>>Subject: [PATCH] pata_efar: MWDMA0 is unsupported
> 
> >>>>MWDMA0 timings cannot be met with the PIIX based controller
> >>>>programming interface.
> 
> >>>The efar documentation makes no reference to not being capable of MWDMA0,
> >>>so where does this come from ? No MWDMA0 is an Intel erratum it appears.
> 
> >>No MWDMA0 support is a common issue on all 'PIIX-like' controllers.
> 
> >>In case of this chipset while the (preliminary) documentation claims MWDMA0
> >>support on the 'FEATURES' page the later 'programming guide' part describes
> >>only PIO0-4, SWDMA2, MWDMA1-2 and UDMA0-4 transfer modes as supported.
> 
> > Cool - I only have the original docs.
> 
>     Hm, me too... perhaps worth putting in Jeff's documentation archive?

Me too?  I just have what 'The Good Uncle Google' has..

--
Bartlomiej Zolnierkiewicz
