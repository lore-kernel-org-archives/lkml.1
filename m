Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbYAVNJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbYAVNJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 08:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbYAVNJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 08:09:15 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42636 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751188AbYAVNJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 08:09:14 -0500
Date: Tue, 22 Jan 2008 13:05:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andreas Dilger <adilger@sun.com>
Cc: Valdis.Kletnieks@vt.edu, David Chinner <dgc@sgi.com>,
       Valerie Henson <val@vahconsulting.com>, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@clusterfs.com>,
       Ric Wheeler <ric@emc.com>
Subject: Re: [RFC] Parallelize IO for e2fsck
Message-ID: <20080122130541.2706e0a0@lxorguk.ukuu.org.uk>
In-Reply-To: <20080122070050.GM3180@webber.adilger.int>
References: <70b6f0bf0801161322k2740a8dch6a0d6e6e112cd2d0@mail.gmail.com>
	<70b6f0bf0801161330y46ec555m5d4994a1eea7d045@mail.gmail.com>
	<20080121230041.GL3180@webber.adilger.int>
	<20080122033830.GR155259@sgi.com>
	<3673.1200975438@turing-police.cc.vt.edu>
	<20080122070050.GM3180@webber.adilger.int>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'd tried to advocate SIGDANGER some years ago as well, but none of
> the kernel maintainers were interested.  It definitely makes sense
> to have some sort of mechanism like this.  At the time I first brought
> it up it was in conjunction with Netscape using too much cache on some
> system, but it would be just as useful for all kinds of other memory-
> hungry applications.

There is an early thread for a /proc file which you can add to your
poll() set and it will wake people when memory is low. Very elegant and
if async support is added it will also give you the signal variant for
free.

Alan
