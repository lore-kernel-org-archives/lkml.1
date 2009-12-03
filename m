Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbZLCWrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbZLCWrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbZLCWrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:47:09 -0500
Received: from mail-ew0-f222.google.com ([209.85.219.222]:55310 "EHLO
	mail-ew0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbZLCWrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:47:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=w5zmGdERkzmmoSAR/GDvebQGFO5AVmLBTxoGYOHA1Q0n3pSn81XIKhi6IAU3kBa/vH
         XeoTnpr6tvKcJx2frVFCc3MEUNgrHwLRcePCFwjgiQsUFgPAkdq8JmrcB4d8iJ0K0JiQ
         GmDt/e11SLaIxJ9rHbMlPcUz/ow2IcHrhy6Vc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 00/86] PATA fixes
Date: Thu, 3 Dec 2009 23:45:58 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <200912032323.39846.bzolnier@gmail.com> <4B183C1A.3080609@garzik.org>
In-Reply-To: <4B183C1A.3080609@garzik.org>
MIME-Version: 1.0
Message-Id: <200912032345.58339.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 December 2009 11:30:50 pm Jeff Garzik wrote:
> On 12/03/2009 05:23 PM, Bartlomiej Zolnierkiewicz wrote:
> > On Thursday 03 December 2009 11:10:51 pm Jeff Garzik wrote:
> >> Is it good kernel practice to intermingle cosmetic changes with
> >> functional ones, in the same code lines?  Also, no.
> >
> > I prefer using common sense over black-and-white rules.
> >
> > If patch is a _really_ tiny one (<  20 LOC changed) it sometimes makes
> > sense to save the time on handling separate patches.
> 
> This is open source -- you have to consider the time saved by reviewers too.

Like I said previously this is best done on per-case basis and because it is
open source eventually people will come up with an alternative patch if they
find the current one too bothersome to review, merge etc.

> But I doubt you have saved time on all your motivated commit searches, so...

Well, just two basic searches limited to one contributor and one directory..

--
Bartlomiej Zolnierkiewicz
