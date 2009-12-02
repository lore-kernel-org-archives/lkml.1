Return-Path: <linux-kernel-owner+w=401wt.eu-S1755037AbZLBBH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbZLBBH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 20:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbZLBBH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 20:07:56 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:48923 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbZLBBHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 20:07:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=UDwLuQl5449ZOmmbwID0GrAQ6vw9eEx43bZ/oUFSd8UaH8B/Zl2ws3T2+p+ozaQ+v5
         k/PuQzoonmFAN7w15XEv+uD2plteDMdkmws85kEELr2qVtcYs6ctbnqfYzN/WOijAOhT
         FBZdny9FBN1b2hZlMEufpzQ+X7gaIsz0hadN4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Subject: Re: [PATCH] add PATA host controller support for Cirrus Logic's EP93xx CPUs
Date: Wed, 2 Dec 2009 02:06:59 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org,
       Sergei Shtylyov <sshtylyov@ru.montavista.com>,
       Joao Ramos <joao.ramos@inov.pt>,
       H Hartley Sweeten <hsweeten@visionengravers.com>
References: <200911261651.40928.bzolnier@gmail.com> <4B15BAA1.2010408@bluewatersys.com>
In-Reply-To: <4B15BAA1.2010408@bluewatersys.com>
MIME-Version: 1.0
Message-Id: <200912020206.59659.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 December 2009 01:53:53 am Ryan Mallon wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > Based on the older IDE host driver by Joao Ramos and review comments
> > for it from Sergei Shtylyov.  Not yet tested with the real hardware.
> >
> 
> Hi Bartlomiej,
> 
> I have got as far as patching this into my kernel and doing a build test
> (still need to find a hard-disk to test). I got some build errors, see
> below:

Hi,

Many thanks for picking this driver up.

The following preparatory libata one-liner is needed to make it build:

	http://patchwork.kernel.org/patch/62926/

and you may also need to update ep93xx ide gpio patch:

	http://thread.gmane.org/gmane.linux.ports.arm.kernel/57688/focus=58730

to current kernels to make the hardware work.

--
Bartlomiej Zolnierkiewicz
