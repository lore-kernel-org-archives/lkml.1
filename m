Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab0CDNnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 08:43:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56844 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843Ab0CDNna convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 08:43:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Wookey <wookey@wookware.org>
Subject: Re: yaffs2 NAND fs
Date: Thu, 4 Mar 2010 14:43:14 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20100304123420.GW27571@dream.aleph1.co.uk>
In-Reply-To: <20100304123420.GW27571@dream.aleph1.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201003041443.14780.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+EIKuhqGwYrvn/DnhO1Iq0qAglV8/X4PFTqLg
 t40HOCey536ak3tKLn78iCEqnk6giNWzbtbOVcj81jVKfBVbV8
 D8mo2k9MHGD6SSxVCXsAg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 March 2010, Wookey wrote:
> So, I guess this is another kick. I'll update the mainline patch I
> have (which is essentially just YAFFS2 with all the "#ifdef kernel
> nnn" code taken out, and the YAFFS-direct and ecos and WinCE code
> removed, to current kernel (which also means updating balloon3 to current
> kernel so I can actually test it). I'll put that in git and ask people
> to take a look. Detailed suggestions on what extra info is needed or
> changes made would be very helpful.
> 
> Unless of course there is already concensus that this is a waste of
> time and Peter and I are the only people that want to see it in
> mainline?

The bar for getting stuff into the kernel has gotten a lot lower these
days, at least for the staging part, see
http://www.kroah.com/log/linux/linux-staging-update.html

The basic requirement would be that you can get a patch that adds
a populated drivers/staging/yaffs2 directory actually builds, ideally
even mounts existing file sytem images without crashing every time ;-)

>From there, you can do all the cleanups that are necessary to
get it moved to fs/yaffs2, including the stuff you mention above
and whatever else comes up (put it into drivers/staging/yaffs2/TODO).

	Arnd
