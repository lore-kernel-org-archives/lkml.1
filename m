Return-Path: <linux-kernel-owner+w=401wt.eu-S1760830AbZKZQa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760830AbZKZQa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760814AbZKZQaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:30:55 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:47429 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833AbZKZQav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:30:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=U9GYr9uxSOnF0z/PGs1/UPolAw6a6XGwxuRrGolowrKc5BOipHY8LFt7j1pNmhMEKy
         9hlz6RWIVSCWF/2woNV1OKAxONCN+qYHP2XEKn1cCA/V9tP0AzemSThKYjrd4Q/aBTcK
         kVlZ/Zh6oFRe6M4nhrAzeFR+hGNe6P+QGvzMo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 16/86] pata_efar: MWDMA0 is unsupported
Date: Thu, 26 Nov 2009 17:29:46 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <200911261640.39208.bzolnier@gmail.com> <4B0EA9FC.1000208@ru.mvista.com>
In-Reply-To: <4B0EA9FC.1000208@ru.mvista.com>
MIME-Version: 1.0
Message-Id: <200911261729.46700.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 November 2009 05:17:00 pm Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
> >>>>>>MWDMA0 timings cannot be met with the PIIX based controller
> >>>>>>programming interface.
> 
> >>>>>The efar documentation makes no reference to not being capable of MWDMA0,
> >>>>>so where does this come from ? No MWDMA0 is an Intel erratum it appears.
> 
> >>>>No MWDMA0 support is a common issue on all 'PIIX-like' controllers.
> 
> >>>>In case of this chipset while the (preliminary) documentation claims MWDMA0
> >>>>support on the 'FEATURES' page the later 'programming guide' part describes
> >>>>only PIO0-4, SWDMA2, MWDMA1-2 and UDMA0-4 transfer modes as supported.
> 
> >>>Cool - I only have the original docs.
> 
> >>    Hm, me too... perhaps worth putting in Jeff's documentation archive?
> 
> > Me too?  I just have what 'The Good Uncle Google' has..
> 
>     Well, I've googled for it and was unable to find any valid links even to 
> my preliminary version anymore. Perhaps I haven't looked hard enough...

Maybe... ;)

FWIW my file is called 38384_SMSC_SLC90E66.pdf

--
Bartlomiej Zolnierkiewicz
