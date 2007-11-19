Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbXKSXAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbXKSXAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 18:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbXKSXAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 18:00:38 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52043 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752257AbXKSXAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 18:00:37 -0500
Date: Mon, 19 Nov 2007 22:58:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: davids@webmaster.com
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Time-based RFC 4122 UUID generator
Message-ID: <20071119225849.4cbb7e37@the-village.bc.nu>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKCECCIFAC.davids@webmaster.com>
References: <fhqbkn$ttt$1@ger.gmane.org>
	<MDEHLPKNGKAHNMBLJOLKCECCIFAC.davids@webmaster.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Any UUID generator that can produce duplicate UUIDs with probability
> significantly less than purely random UUIDs is so badly broken that it
> should not ever be used. Anyone who finds such a UUID generator should
> immediately either fix it or throw it on the junk heap. Anyone who knowingly
> uses such a UUID generator should be publically shamed.

That depends what they are using it for. Deliberately colliding with
other UUIDs is sometimes highly desirable, just not usually in productive
circles.
