Return-Path: <linux-kernel-owner+w=401wt.eu-S1756362AbYDPW2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbYDPW2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 18:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbYDPW1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 18:27:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:54778 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbYDPW1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 18:27:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=w90cfbJOdvVvbxeIj6nsygAUfAFXKJ6nR4itVUUpTkD0HddT2OtHg/zbp77evpT8jzj+j2nEDn1lzMk2wAOtZ7pey2c5hx9FHaRNSFK3F2vhug0m7NITHeiPFSJ9O2SjpWg26ZH0ZmS3BlE9/m4LbjPGQVB4d3mjdC7KXLBHFcs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 2/6] scc_pata: add ->{in,out}put_data methods
Date: Thu, 17 Apr 2008 00:09:43 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200803302141.06106.bzolnier@gmail.com> <480638EA.2000708@ru.mvista.com>
In-Reply-To: <480638EA.2000708@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804170009.44039.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 April 2008, Sergei Shtylyov wrote:
> Bartlomiej Zolnierkiewicz wrote:
> 
> > There should be no functional changes caused by this patch.
> 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> > Index: b/drivers/ide/pci/scc_pata.c
> > ===================================================================
> > --- a/drivers/ide/pci/scc_pata.c
> > +++ b/drivers/ide/pci/scc_pata.c
> > @@ -574,6 +574,36 @@ static int __devinit init_setup_scc(stru
> >  	return ide_setup_pci_device(dev, d);
> >  }
> 
>     This patch in the pata-2.6 series doesn't apply anymore after the patch 
> getting rid of ide_setup_pci_device() call was merged.

I updated it in IDE tree while merging Akira's patch but it turned out
that "take 2" was needed anyway...
