Return-Path: <linux-kernel-owner+w=401wt.eu-S933588AbYCFMxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933588AbYCFMxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760618AbYCFMxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 07:53:09 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:42422 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765660AbYCFMw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 07:52:57 -0500
Subject: Re: [PATCH] Modify loop device to be able to manage partitions of
	the disk image
From: Laurent Vivier <Laurent.Vivier@bull.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080306123551.GA10609@infradead.org>
References: <1204796612842-git-send-email-Laurent.Vivier@bull.net>
	 <20080306123551.GA10609@infradead.org>
Content-Type: text/plain; charset=utf-8
Organization: Bull S.A.S.
Date: Thu, 06 Mar 2008 13:55:19 +0100
Message-Id: <1204808119.4325.31.camel@frecb07144>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le jeudi 06 mars 2008 à 07:35 -0500, Christoph Hellwig a écrit :
> On Thu, Mar 06, 2008 at 10:43:32AM +0100, Laurent Vivier wrote:
> > This patch allows to use loop device with partitionned disk image.
> > 
> > Original behavior of loop is not modified.
> > 
> > A new parameter is introduced to define how many partition we want to be
> > able to manage per loop device. This parameter is "max_part".
> 
> I've done something else before as have done others, but at that time
> we didn't want it in because it breaks the device number encoding.
> 
> Nowdays where a lot of systems use udev it probably makes sense to put
> it in.  The default is to not show any partitions which is safe.  Did
> you test if udev is smart enough to find out loop has partitions when
> loaded with the paramater?  If yes this can go in with a little

Well, my system is a Debian Etch, and all loop devices and loop
partitions are created automatically, so I imagine udev is working fine
with that...

> documentation added, if not please also work with the udev folks to
> find a way to automatically detect that loop can sometimes support
> partitions.

Laurent
-- 
----------------- Laurent.Vivier@bull.net  ------------------
"Programmers who subconsciously view themselves as artists
 will enjoy what they do and will do it better." D. Knuth

