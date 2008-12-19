Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYLSKua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYLSKua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 05:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbYLSKuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 05:50:22 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51507 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751655AbYLSKuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 05:50:21 -0500
Date: Fri, 19 Dec 2008 10:50:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, Jeff Garzik <jeff@garzik.org>,
       Mario Schwalbe <schwalbe@inf.tu-dresden.de>,
       linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] ide: Fix ata_id_has_dword_io to return DWORD I/O
 support properly
Message-ID: <20081219105013.0e43c364@lxorguk.ukuu.org.uk>
In-Reply-To: <200812190013.10156.bzolnier@gmail.com>
References: <494A5BBF.8000807@inf.tu-dresden.de>
	<200812182142.16533.bzolnier@gmail.com>
	<20081218224010.45e3ce55@lxorguk.ukuu.org.uk>
	<200812190013.10156.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sure, we can always improve things further later.  However Mario's patch
> is _definitely_ an improvement over the _current_ code.  Don't you agree?

No actually I don't. The current head dev code checks ATA > 7 as the
indicator that this bit is used for treacherous computing. That means the
behaviour for all the older drives is clearly back compatible with old
Linux behaviour.

Doing it that way around means we don't have any worries about changing
existing behaviours.
