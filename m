Return-Path: <linux-kernel-owner+w=401wt.eu-S1757958AbYAPASM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbYAPASM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 19:18:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbYAPAR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 19:17:57 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46881 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751533AbYAPARz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 19:17:55 -0500
Date: Wed, 16 Jan 2008 00:15:03 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Daniel Phillips" <phillips@google.com>
Cc: "Pavel Machek" <pavel@ucw.cz>, "David Chinner" <dgc@sgi.com>,
       "Theodore Tso" <tytso@mit.edu>, "Al Boldi" <a1426z@gawab.com>,
       "Valerie Henson" <val.henson@gmail.com>,
       "Rik van Riel" <riel@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental
 fsck)
Message-ID: <20080116001503.3c0c97cf@lxorguk.ukuu.org.uk>
In-Reply-To: <4d47a5d10801151544k3bc50223ob69c25d8732e3f12@mail.gmail.com>
References: <200801090022.55589.a1426z@gawab.com>
	<200801090740.12989.a1426z@gawab.com>
	<70b6f0bf0801082345vf57951ey642e35c3d6e5194f@mail.gmail.com>
	<200801091452.14890.a1426z@gawab.com>
	<20080112145140.GB6751@mit.edu>
	<20080113171916.GB4132@ucw.cz>
	<20080113174125.5f39ac64@lxorguk.ukuu.org.uk>
	<20080115201653.GA5639@elf.ucw.cz>
	<20080115214325.GN155407@sgi.com>
	<20080115230714.GC3573@elf.ucw.cz>
	<4d47a5d10801151544k3bc50223ob69c25d8732e3f12@mail.gmail.com>
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

> Writeback cache on disk in iteself is not bad, it only gets bad if the
> disk is not engineered to save all its dirty cache on power loss,
> using the disk motor as a generator or alternatively a small battery.
> It would be awfully nice to know which brands fail here, if any,
> because writeback cache is a big performance booster.

AFAIK no drive saves the cache. The worst case cache flush for drives is
several seconds with no retries and a couple of minutes if something
really bad happens.

This is why the kernel has some knowledge of barriers and uses them to
issue flushes when needed.
