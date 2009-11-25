Return-Path: <linux-kernel-owner+w=401wt.eu-S932922AbZKYRuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922AbZKYRuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:50:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932858AbZKYRuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:50:11 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:40243 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759153AbZKYRuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:50:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=K4qrbUsh0xSf/1peO9fI7/YUaUEeAVwV+UD+98vt4t7InwoF543aDkZqE5KiLTV9AW
         My9CYWbpdZvMs5SfcLv/k/wmwFr0QC00La4Ez95KZ5e6WJKWTBPSM+oxJNJbKQ6UvJ88
         0pMJY2cUW20AtatIwgrnBuVqQRlOfPaWbdOzg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 69/86] pata_scc: add 32-bit PIO support
Date: Wed, 25 Nov 2009 18:49:23 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <20091125171039.5446.68680.sendpatchset@localhost> <20091125174844.7e7b3106@lxorguk.ukuu.org.uk>
In-Reply-To: <20091125174844.7e7b3106@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911251849.23835.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 November 2009 06:48:44 pm Alan Cox wrote:
> On Wed, 25 Nov 2009 18:10:39 +0100
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] pata_scc: add 32-bit PIO support
> > 
> > There shouldn't be any problems with it as IDE scc_pata host driver
> > has been allowing 32-bit PIO operations for years.
> 
> NAK; Read the code - it uses its own private data_xfer handler anyway

Ah, this one can be indeed dropped.

--
Bartlomiej Zolnierkiewicz
