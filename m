Return-Path: <linux-kernel-owner+w=401wt.eu-S933446AbZKYRUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933446AbZKYRUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759072AbZKYRUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:20:13 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:50925 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295AbZKYRUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:20:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=MwTvVHpjjoarErjwNB6uTFvymawiUV8XJRrTN2RO943OLgEDY+I+Z8TF6O0xPticAF
         L/Z2eC52nQwzIMnllBkQ9Sb7ujEsb+PBcOo8qcjlwdlBvzdWaCwsH+MUVzujbqyKfj2j
         eIXrLs6L2wcAQsNfEURCt1ZayT/0Oapq/RhxM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 03/86] pata_artop: add 32-bit PIO support
Date: Wed, 25 Nov 2009 18:18:18 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <20091125170239.5446.26287.sendpatchset@localhost> <20091125171242.70b8019f@lxorguk.ukuu.org.uk>
In-Reply-To: <20091125171242.70b8019f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <200911251818.18521.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 November 2009 06:12:42 pm Alan Cox wrote:
> On Wed, 25 Nov 2009 18:02:39 +0100
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] pata_artop: add 32-bit PIO support
> > 
> > There shouldn't be any problems with it as IDE aec62xx host driver
> > has been allowing 32-bit PIO operations for years.
> 
> Allowing or defaulting too ?

For aec62xx: allowing, for some other drivers: defaulting ('using'
in the patch description instead of 'allowing').  However some
popular distributions have been defaulting to always enabling it
if was supported by the driver.

--
Bartlomiej Zolnierkiewicz
