Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbYG2TwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbYG2TwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 15:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757881AbYG2Tvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 15:51:35 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:8371 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbYG2Tve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 15:51:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=AobZ4SpeiTxn4HpKE2OxGprraeSuE/ZJujAcr5Kvtx/zCo5eQq4narVtgXAEBnQZjA
         bzmx5IRhWvsa42NAWGGVvl34cmqDCFovpFepeEv0IuIIyDYT2SlLcO1nSnJ45+oW6Rj4
         2qBlgaGoM/eFphpq6qJppXPyfYeYFtMiQ7AX8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] remove CONFIG_IDE_MAX_HWIFS
Date: Tue, 29 Jul 2008 21:45:21 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080727130448.GK9301@cs181140183.pp.htv.fi> <200807271632.16417.bzolnier@gmail.com> <20080729164801.GB23951@cs181140183.pp.htv.fi>
In-Reply-To: <20080729164801.GB23951@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807292145.21681.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 July 2008, Adrian Bunk wrote:
> On Sun, Jul 27, 2008 at 04:32:16PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Sunday 27 July 2008, Adrian Bunk wrote:
> >...
> > > <--  snip  -->
> > > 
> > > Considering the little benefits of all this fiddling with IDE_MAX_HWIFS 
> > > I decided to fix it through a simplification:
> > > - always #define MAX_HWIFS      CONFIG_IDE_MAX_HWIFS
> > > - always set CONFIG_IDE_MAX_HWIFS in kconfig
> > > - let IDE_MAX_HWIFS default to 10
> > > - allow changing the value of IDE_MAX_HWIFS only if IDE && EMBEDDED
> > 
> > I was actually wondering whether it is worth to keep IDE_MAX_HWIFS
> > now that ide_hwif_t instances are allocated dynamically.
> > 
> > [ The difference between MAX_HWIFS == 10 and MAX_HWIFS == 2 is now
> >   ~100 bytes (x86_32) and between MAX_HWIFS == 10 and MAX_HWIFS == 1
> >   it is ~1kb (IIRC). ]
> > 
> > Since there were also many other improvements in shrinking drivers/ide/
> > code size which should keep embedded users happy and compensate for
> > the above 1kB-worst-case I would prefer to have IDE_MAX_HWIFS removed
> > completely.
> >...
> 
> Patch below.

applied

Thanks Adrian!
