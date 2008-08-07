Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbYHGRP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbYHGRP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbYHGRPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:15:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:24895 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155AbYHGRPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:15:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=ahA/5cu53areFxdzWExSqn7RTtj+n6JYhRy2upGM51yn0ucXvFConz1e9ddd7sa7uo
         vINA/UMSrY0nQZiEhr9rFvfnAWVoM9A/d2nUSj40frisWPYQN8g988JSHLB8tTn5twag
         zHteyNAd+mo8gUeVycQH0TGTVql4lcM/8tnqY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH] ide-generic: handle probing of legacy io-ports v5 (was: Re: [PATCH 1/2] pata_legacy: export functionality to ide)
Date: Thu, 7 Aug 2008 19:06:35 +0200
User-Agent: KMail/1.9.9
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20080803165135.GA31977@gollum.tnic> <489A03C3.5070607@ru.mvista.com> <20080807043621.GA3771@gollum.tnic>
In-Reply-To: <20080807043621.GA3771@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808071906.35569.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 07 August 2008, Borislav Petkov wrote:

[...]

> Here's v5:
> 
> ---
> From: Borislav Petkov <petkovbb@gmail.com>
> Date: Sun, 3 Aug 2008 18:46:35 +0200
> Subject: [PATCH] ide-generic: handle probing of legacy io-ports v5
> 
> Avoid probing the io-ports in case an IDE PCI controller is present and it
> uses the legacy iobases. If we still want to enforce the probing, we do
> 
> ide_generic.probe_mask=0x3f
> 
> on the kernel command line. The iobase checking code is
> adapted from drivers/ata/pata_legacy.c after converting hex
> pci ids into their corresponding macros in <linux/pci_ids.h>.
> 
> Also, check only BAR0/2 resources since those are guaranteed
> by the workaround in drivers/pci/probe.c:pci_setup_device().
> 
> CC: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied, thanks
