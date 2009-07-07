Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbZGGWKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbZGGWKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 18:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbZGGWKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 18:10:11 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:50573 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbZGGWKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 18:10:10 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: tridge@samba.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Date: Wed, 8 Jul 2009 00:09:57 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.29.6-tp42-toi-3.0.1-00977-gf7efeea; KDE/4.2.4; i686; ; )
Cc: Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, James.Bottomley@hansenpartnership.com
References: <19013.8005.541836.436991@samba.org> <19026.38137.63807.427511@samba.org> <200907072356.51553.Martin@lichtvoll.de> (sfid-20090708_000757_795028_44BD7FFF)
In-Reply-To: <200907072356.51553.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907080009.58519.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 07 Juli 2009 schrieb Martin Steigerwald:
> I think the patch actively corrupts perfectly fine shortname FAT
> filesystems and at least for certain use scenarios even those with long
> name support.

Well for short name FAT only if it gets a chance to. I.e. when the 
filesystem is mounted as vfat.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
