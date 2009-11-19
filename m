Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbZKSObz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbZKSObz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 09:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbZKSObz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 09:31:55 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35610 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753346AbZKSOby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 09:31:54 -0500
Date: Thu, 19 Nov 2009 14:33:51 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 4/5] pata: Update experimental tags
Message-ID: <20091119143351.1d0e2c59@lxorguk.ukuu.org.uk>
In-Reply-To: <200911191517.15090.bzolnier@gmail.com>
References: <20091117144450.15430.83450.stgit@localhost.localdomain>
	<200911182056.16517.bzolnier@gmail.com>
	<20091119131636.15800a11@linux.intel.com>
	<200911191517.15090.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009 15:17:14 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> On Thursday 19 November 2009 14:16:36 Alan Cox wrote:
> > > Only pata_hpt37x has broken cable detection while pata_hpt3x2n is
> > > okay. ;)
> > 
> > I think you have that backwards according to the vendor drivers. 3x2n
> > looks like it needs adjusting.
> 
> lol, just fix the damn pata_hpt37x driver _lacking_ ->cable_detect method..

It doesn't need one. It still sets the cable type in the pre reset
function as the older drivers that haven't converted to a cable_detect
method do.
