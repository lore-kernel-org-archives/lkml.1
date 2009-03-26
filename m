Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbZCZM4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbZCZM4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 08:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756635AbZCZM4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 08:56:31 -0400
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:46970 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756034AbZCZM4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 08:56:30 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-01.arcor-online.net 9F8E0232E63
Date: Thu, 26 Mar 2009 13:56:24 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Andreas Robinson <andr345@gmail.com>
cc: Bodo Eggert <7eggert@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: fastboot: unpacking initramfs faster
In-Reply-To: <1238068631.12756.23.camel@andreas-desktop>
Message-ID: <alpine.LSU.0.999.0903261354380.6387@be1.lrz>
References: <cj9yI-540-17@gated-at.bofh.it>  <E1LmEqj-0001SN-6Y@be1.7eggert.dyndns.org>
  <1238053964.8304.24.camel@andreas-desktop>  <alpine.LSU.0.999.0903261216550.5843@be1.lrz>
 <1238068631.12756.23.camel@andreas-desktop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009, Andreas Robinson wrote:
> On Thu, 2009-03-26 at 12:26 +0100, Bodo Eggert wrote:
> > On Thu, 26 Mar 2009, Andreas Robinson wrote:
> > > On Tue, 2009-03-24 at 23:11 +0100, Bodo Eggert wrote:
> [snip]

> > > > Why not make a new set? http://7eggert.dyndns.org:8080/l/bgz.tar.gz

> The file permissions are wrong, I'm not allowed to download it.

fixed

> > Thinking about it: It's now very kernel-specific, other users might like a
> > block signature to make it robust against errors - e.g. in the middle of a
> > .tar.bgz file. I think I'll change that soon and put 0x55aa in front of
> > each block.
> 
> I think we'll want an optional checksum of the compressed data.
> Suppose bit 32 in the compressed block size field is set, the next field
> is the block's Adler32 checksum.
> (the adler32 source is in include/linux/zutil.h)

I will think about it.
-- 
Funny quotes:
5. 99 percent of lawyers give the rest a bad name.
