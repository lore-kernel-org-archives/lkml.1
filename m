Return-Path: <linux-kernel-owner+w=401wt.eu-S1759568AbZLOJ53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568AbZLOJ53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 04:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759443AbZLOJ52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 04:57:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63845 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbZLOJ51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 04:57:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Neil Brown <neilb@suse.de>
Subject: Re: linux-next: manual merge of the md-current tree with Linus' tree
Date: Tue, 15 Dec 2009 10:57:20 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091214102428.f50557a0.sfr@canb.auug.org.au> <200912141127.27019.arnd@arndb.de> <20091215140502.5edd6678@notabene.brown>
In-Reply-To: <20091215140502.5edd6678@notabene.brown>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912151057.20807.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/nKGq6rDPMfpEgK31sRE7p1VRlnoUnTynxfjW
 w7C9M6/3c8TXH0pxJur4oE2KrFoDiYpbNpjLxE8PUzlIxZd+iD
 qLEnkw3iowHpD7RjM62TQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 December 2009, Neil Brown wrote:
> I had already rebased that patch on the lasted from Linus and asked him to
> pull again.
> He how seems to have done that, so md should be up-to-date in -linus,
> including the compat_ioctl stuff.
> If you would like to double check that it matches what you expect, that would
> be great.

The old ULONG_IOCTL numbers (HOT_{ADD,REMOVE}_DISK, SET_DISK_FAULTY
and SET_BITMAP_FILE) that Stephen missed are still left in fs/compat_ioctl.c,
but that is completely harmless. I'll remove them in my next batch of cleanups,
which can probably wait until 2.6.34.

Thanks for your help,

	Arnd
