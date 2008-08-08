Return-Path: <linux-kernel-owner+w=401wt.eu-S1757001AbYHHQeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbYHHQeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbYHHQdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:33:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:23063 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbYHHQds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:33:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=NLGvev5tvFlhZIoryw1CVE3jne0UboAWvbyPC66+ZmtcWt3OcU5VFw8ziu+0nwORk1
         xSPoZtAvUKXEwUjrGA3J8CvEwe3RDNFwNvmHrCZBOi/4oDJfoV/tJ/PoX0zTq54gPzyW
         ihUCYSJd4KaOyCym/t52MbdQ8Q0dOWxm6Km10=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] drivers/ide/pci/: use __devexit_p()
Date: Fri, 8 Aug 2008 18:14:58 +0200
User-Agent: KMail/1.9.9
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
References: <20080807164539.GA26947@flint.arm.linux.org.uk> <20080807170932.GC9692@cs181140183.pp.htv.fi>
In-Reply-To: <20080807170932.GC9692@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808081814.58997.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 August 2008, Adrian Bunk wrote:
> On Thu, Aug 07, 2008 at 05:45:39PM +0100, Russell King wrote:
> >...
> > --- a/drivers/ide/pci/hpt366.c
> > +++ b/drivers/ide/pci/hpt366.c
> > @@ -1594,7 +1594,7 @@ static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_devic
> >  	return ret;
> >  }
> >  
> > -static void __devexit hpt366_remove(struct pci_dev *dev)
> > +static void hpt366_remove(struct pci_dev *dev)
> >...
> 
> Thanks for your report.
> 
> The code is buggy, but:
> - that's not the correct fix and
> - there are far more such bugs under drivers/ide/pci/
> 
> Patch below.
> 
> > Russell King
> 
> cu
> Adrian
> 
> 
> <--  snip  -->
> 
> 
> This patch adds missing __devexit_p's.
> 
> Reported-by: Russell King <rmk+lkml@arm.linux.org.uk>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

applied, thanks
