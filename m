Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbZCZL0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbZCZL0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 07:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbZCZL0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 07:26:42 -0400
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:38816 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750849AbZCZL0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 07:26:41 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-03.arcor-online.net 0E1F52C353B
Date: Thu, 26 Mar 2009 12:26:35 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Andreas Robinson <andr345@gmail.com>
cc: 7eggert@gmx.de, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: fastboot: unpacking initramfs faster
In-Reply-To: <1238053964.8304.24.camel@andreas-desktop>
Message-ID: <alpine.LSU.0.999.0903261216550.5843@be1.lrz>
References: <cj9yI-540-17@gated-at.bofh.it>  <E1LmEqj-0001SN-6Y@be1.7eggert.dyndns.org>
 <1238053964.8304.24.camel@andreas-desktop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009, Andreas Robinson wrote:
> On Tue, 2009-03-24 at 23:11 +0100, Bodo Eggert wrote:
> > Andreas Robinson <andr345@gmail.com> wrote:

> > > I then looked at multithreaded decompression and found that neither gzip
> > > files nor deflate streams provide enough information (eg block lengths)
> > > to let you share the decompression among threads.
> > > 
> > > It can be done of course, but obviously not without modifying file
> > > formats and userspace tools.
> > > 
> > > (Thoughts of snowballs and hell presented themselves at this point.)
> > 
> > Why not make a new set? http://7eggert.dyndns.org:8080/l/bgz.tar.gz
> 
> Hmm, well if you think there is a chance of it being accepted, then
> sure! I'll cook something up, but will be looking to use LZO first since
> it's a bit faster to begin with.

It's small enough, and now I've updated it to support lzo and put a
license into the files.

Thinking about it: It's now very kernel-specific, other users might like a
block signature to make it robust against errors - e.g. in the middle of a
.tar.bgz file. I think I'll change that soon and put 0x55aa in front of
each block.
-- 
Borges sumus. Resistere inutile est.
