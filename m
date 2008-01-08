Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbYAHSte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbYAHSte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYAHSt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:49:26 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50293 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751186AbYAHSt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:49:26 -0500
Date: Tue, 8 Jan 2008 18:47:17 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tuomo Valkonen <tuomov@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080108184717.0abcb312@lxorguk.ukuu.org.uk>
In-Reply-To: <slrnfo7gse.fne.tuomov@jolt.modeemi.cs.tut.fi>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi>
	<20080108164847.GA16462@skl-net.de>
	<slrnfo7e3i.c37.tuomov@jolt.modeemi.cs.tut.fi>
	<20080108182904.GB16462@skl-net.de>
	<slrnfo7gse.fne.tuomov@jolt.modeemi.cs.tut.fi>
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

> be a bit longer), but it gets confused and thinks it's been years since
> last check, when it hasn't. I have my doubts that Theodore Tso's reply
> is the problem here, because I didn't use to have this problem; it 
> appeared relatively recently. But maybe old versions of e2fsck were

This is a bug in your system or distribution. We used to see it years ago
when the disk caches didn't get flushed before power off. The last write
would vanish and on a shutdown was almost always the superblock time
update.

Alan
