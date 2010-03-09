Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab0CIXqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 18:46:36 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62655 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab0CIXqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 18:46:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tejun Heo <tj@kernel.org>
Subject: Re: ATA 4 KiB sector issues.
Date: Wed, 10 Mar 2010 00:46:24 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.33-00022-gabde0f8; KDE/4.4.0; x86_64; ; )
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
References: <4B947393.2050002@kernel.org>
In-Reply-To: <4B947393.2050002@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003100046.24695.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+aAao4Mwv0kwmVhZImaG7II4xPjryWlZWr0U3
 2p1bRPbNSj56/nIHFZpi9uI/TTpjs7fK0hKr1zAYTt16xOuwfm
 EpmpNEsao+0iH2ICMENfA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 March 2010 04:48:35 Tejun Heo wrote:
> Unfortunately, while Windows can assume that newer releases won't
> share the hard drive with older releases including Windows XP, Linux
> distros can't do that.  There will be many installations where a
> modern Linux distros share a hard drive with older releases of
> Windows.  At this point, I can't see a silver bullet solution.
> 
> Partitioners maybe should only align partitions which will be used by
> Linux and default to the traditional layout for others while allowing
> explicit override.  I think Windows XP wouldn't have problem with
> differently aligned partitions as long as it doesn't actually use them
> but haven't tested it.

Any idea if XP can cope with partition tables that use a 32-sector, 128-head
geometry rather than the default 63-sector, 255-head one? That seems to
be what some flash memory cards are using and it would make any cylinder
aligned partition also 4096-byte aligned, at the cost of moving the
1024-cylinder boundary from 7.88 GiB to 2 GiB.

Do we know of anything that requires 63s/255h?

	Arnd
