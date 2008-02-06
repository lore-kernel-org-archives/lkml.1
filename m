Return-Path: <linux-kernel-owner+w=401wt.eu-S1759614AbYBFTwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614AbYBFTwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 14:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755534AbYBFTwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 14:52:01 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:28133 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbYBFTv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 14:51:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=HDcICOB1tthKZsJfoRIvoFaxxWGV2vmKaft6ExanVX6ZbnUlcHi9kNQHEBVBgWE3e3kvdf1yvEW1AjXKHFdkErDBlvt7p+LmV5Mtw5JrVWylthqnnxAaHPw0xQzA6r8257sMCG96tsquj1uRtA+83boefOV/t/z43m35eZkXYt8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.26-git0: IDE oops during boot
Date: Wed, 6 Feb 2008 21:05:42 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20080206105334.GA3664@elf.ucw.cz> <20080206110805.GB3613@elf.ucw.cz>
In-Reply-To: <20080206110805.GB3613@elf.ucw.cz>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802062105.42929.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 06 February 2008, Pavel Machek wrote:
> On Wed 2008-02-06 11:53:34, Pavel Machek wrote:
> > Hi!
> > 
> > Trying to boot 2.6.25-git0 (few days old), I get
> > 
> > BUG: unable to handle kernel paging request at ffff..ffb0
> > IP at init_irq+0x42e

init_irq? hmm...

> > Call trace:
> > ide_device_add_all

this comes from ide-generic
(Generic IDE host driver)

> > ide_generic_init
> > kernel_init
> > child_rip
> > vgacon_cursor
> > kernel_init
> > child_rip
> > 
> > Excerpt from config:
> > 
> > CONFIG_IDE=y
> > CONFIG_BLK_DEV_IDE=y
> 
> Disabling CONFIG_IDE made my machine boot, as it was using libata
> anyway.

Kamalesh/Pavel:

Could you try latest git and see if the OOPS is still there?

[ Yeah, I'm unable to reproduce it. :( ]

Thanks,
Bart
