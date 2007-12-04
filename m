Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbXLDRAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbXLDRAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 12:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbXLDRA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 12:00:26 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59379 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753959AbXLDRAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 12:00:25 -0500
Date: Tue, 4 Dec 2007 16:55:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Ray Lee" <ray@madrabbit.org>
Cc: "Adrian Bunk" <bunk@kernel.org>, "Matt Mackall" <mpm@selenic.com>,
       "Marc Haber" <mh+linux-kernel@zugschlus.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071204165502.0a8f695e@the-village.bc.nu>
In-Reply-To: <2c0942db0712040854u17a830b9see663742b2716457@mail.gmail.com>
References: <20071204114125.GA17310@torres.zugschlus.de>
	<20071204161811.GB15974@stusta.de>
	<2c0942db0712040854u17a830b9see663742b2716457@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> cryptographically strong stream it'll provide when /dev/random is
> tapped? In principle, this'd leave more entropy available for
> applications that really need it, especially on platforms that don't
> generate a lot of entropy in the first place (servers).


As reported about a month ago, the evidence is that the /dev/random
stream is not cryptographically strong. Collecting uuids generated from
the kernel uuid random generator from the random generator in the kernel
shows abnormal patterns of duplicates.

Alan
