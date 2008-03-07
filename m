Return-Path: <linux-kernel-owner+w=401wt.eu-S1762818AbYCGMLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762818AbYCGMLl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 07:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756589AbYCGMLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 07:11:33 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:52276 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344AbYCGMLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 07:11:33 -0500
Subject: Re: [PATCH] Modify loop device to be able to manage partitions of
	the disk image
From: Laurent Vivier <Laurent.Vivier@bull.net>
To: 7eggert@gmx.de
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
In-Reply-To: <E1JXbBo-0000ix-57@be1.7eggert.dyndns.org>
References: <a4kTW-44U-25@gated-at.bofh.it> <a4l3D-4hn-11@gated-at.bofh.it>
	 <a4lmN-4Xt-7@gated-at.bofh.it> <a4m9d-6iD-7@gated-at.bofh.it>
	 <E1JXbBo-0000ix-57@be1.7eggert.dyndns.org>
Content-Type: text/plain; charset=utf-8
Organization: Bull S.A.S.
Date: Fri, 07 Mar 2008 13:13:56 +0100
Message-Id: <1204892036.4315.29.camel@frecb07144>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le vendredi 07 mars 2008 à 12:56 +0100, Bodo Eggert a écrit :
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > On Thursday 06 March 2008 21:16, Laurent Vivier wrote:
> >> Le jeudi 06 mars 2008 à 20:57 +1100, Nick Piggin a écrit :
> 
> >> > Do you think we do something similar for drivers/block/brd.c too? I'd
> >> > like to try to maintain parity between them where possible...
> >>
> >> I think it is possible  (I've the same patch for NBD too), but I think
> >> it is completely useless.
> > 
> > It's useful for testing, and for minimising the divergence in the
> > code.
> 
> Maybe there should be a common mechanism to use partitions on any block
> device. Maybe there is - I have dark memories about the device mapper

The mechanism exists: the driver must call alloc_disk() with a value !=
1. This is what is modifying this patch.

> being able to parse partition tables, and plans on moving partition
> support to userspace.

This is kpartx.

Laurent
-- 
----------------- Laurent.Vivier@bull.net  ------------------
"Programmers who subconsciously view themselves as artists
 will enjoy what they do and will do it better." D. Knuth

