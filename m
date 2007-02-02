Return-Path: <linux-kernel-owner+w=401wt.eu-S1423036AbXBBMNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423036AbXBBMNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 07:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423043AbXBBMNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 07:13:43 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:37403 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423036AbXBBMNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 07:13:42 -0500
X-Originating-Ip: 74.109.98.130
Date: Fri, 2 Feb 2007 06:22:25 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Anton Altaparmakov <aia21@cam.ac.uk>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, aia21@cantab.net
Subject: Re: [PATCH] NTFS: Rename apparently incorrect macro name "NTFS_DEBUG".
In-Reply-To: <1170414630.5749.0.camel@imp.csi.cam.ac.uk>
Message-ID: <Pine.LNX.4.64.0702020620320.17217@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0702020543230.16913@CPE00045a9c397f-CM001225dbafb6>
 <1170414630.5749.0.camel@imp.csi.cam.ac.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (cached,
	score=-16.8, required 5, ALL_TRUSTED -1.80, BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Feb 2007, Anton Altaparmakov wrote:

> Hi,
>
> On Fri, 2007-02-02 at 05:46 -0500, Robert P. J. Day wrote:
> >   Replace the apparently incorrect macro name "NTFS_DEBUG" with
> > "CONFIG_NTFS_DEBUG".
> >
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> >
> > ---
> >
> > diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
> > index c577d8e..2154d03 100644
> > --- a/fs/ntfs/attrib.c
> > +++ b/fs/ntfs/attrib.c
> > @@ -1921,7 +1921,7 @@ s64 ntfs_attr_extend_allocation(ntfs_inode *ni, s64 new_alloc_size,
> >  	u32 attr_len = 0; /* Silence stupid gcc warning. */
> >  	bool mp_rebuilt;
> >
> > -#ifdef NTFS_DEBUG
> > +#ifdef CONFIG_NTFS_DEBUG
>
> The fix is also wrong.  It should be:
>
> #ifdef DEBUG
>
> See fs/ntfs/Makefile for details...

ah, yes, i see what you mean.  revised patch coming shortly, i'll send
that one to just the relevant parties.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
