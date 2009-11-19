Return-Path: <linux-kernel-owner+w=401wt.eu-S1754361AbZKSOSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbZKSOSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 09:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbZKSOSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 09:18:20 -0500
Received: from qw-out-1920.google.com ([74.125.92.150]:3832 "EHLO
	qw-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbZKSOST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 09:18:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=rst/BaQ4xRXk/dGGNYvJH9Lr/8hITYOdev4F7difIbA53sCdbbmic9wR95KICwhrhj
         dAevCUcJ4uS4K9BiI7ozVWSpqiKzwt6JurWwx4eVUyR+X3b6sTVyZDYT2QDGt4okZMFu
         Z//7DOIarlEJE7t4WVKdWubVx27OKQo9Hy5G4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 4/5] pata: Update experimental tags
Date: Thu, 19 Nov 2009 15:17:14 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20091117144450.15430.83450.stgit@localhost.localdomain> <200911182056.16517.bzolnier@gmail.com> <20091119131636.15800a11@linux.intel.com>
In-Reply-To: <20091119131636.15800a11@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911191517.15090.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 November 2009 14:16:36 Alan Cox wrote:
> > Only pata_hpt37x has broken cable detection while pata_hpt3x2n is
> > okay. ;)
> 
> I think you have that backwards according to the vendor drivers. 3x2n
> looks like it needs adjusting.

lol, just fix the damn pata_hpt37x driver _lacking_ ->cable_detect method..

-- 
Bartlomiej Zolnierkiewicz
