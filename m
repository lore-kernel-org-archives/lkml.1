Return-Path: <linux-kernel-owner+w=401wt.eu-S1752321AbXBRWiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbXBRWiu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 17:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbXBRWiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 17:38:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57393 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbXBRWit convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 17:38:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH 41/44 take 2] [UBI] gluebi unit header
Date: Sun, 18 Feb 2007 23:37:51 +0100
User-Agent: KMail/1.9.6
Cc: Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <200702180315.25067.arnd@arndb.de> <20070218030217.GH1038@crusty.rchland.ibm.com>
In-Reply-To: <20070218030217.GH1038@crusty.rchland.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702182337.53314.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:bf0b512fe2ff06b96d9695102898be39
X-Provags-ID2: V01U2FsdGVkX193BJmCp/im4TTpffsrqvEvgMSTptmSj/9WHkrhL98t2uN4KkjO//nbxMdWnqD5WJnvGcGEiTdcoFVjPg/5uZz3HEr6uUjJ+/dJXjO8VfaKxA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 February 2007 04:02:17 Josh Boyer wrote:
> On Sun, Feb 18, 2007 at 03:15:23AM +0100, Arnd Bergmann wrote:
> > On Sunday 18 February 2007 03:04, Josh Boyer wrote:
> > > No, the MTD interface isn't flawed.  gluebi is present to make things
> > > like JFFS2 work on top of UBI volumes with very little adaptations.  If
> > > you go changing _every_ MTD user to now use either an MTD device or a
> > > native UBI device, then the code for those users just gets bloated.
> >
> > Right, that was my point. If the MTD API in the kernel is not flawed, why
> > do we need the 'native' UBI interface? Just merge gluebi into UBI and
> > get rid of the extra abstraction.
>
> That suggestion came up several times.  gluebi represents a compromise
> between the two groups.  IIRC, the issue was that representing UBI volumes
> as MTD devices only makes sense in the dynamic volume case.  Static UBI
> volumes require special write/update handling and so there was a need for
> a native interface anyway.

Which brings be back to my original point ;-)

I'm sure this has been discussed before, but I'd still like to understand
what is so special with 'static UBI volumes' that they can't be used with
a slightly extended MTD interface.

	Arnd <><
