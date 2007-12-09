Return-Path: <linux-kernel-owner+w=401wt.eu-S1751935AbXLINjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbXLINjo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 08:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbXLINjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 08:39:37 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53453 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750865AbXLINjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 08:39:36 -0500
Date: Sun, 9 Dec 2007 13:33:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] random: use xor for mixing
Message-ID: <20071209133358.1d43e226@the-village.bc.nu>
In-Reply-To: <20071209020828.GX17037@thunk.org>
References: <2.753618428@selenic.com>
	<3.753618428@selenic.com>
	<20071209000103.GS17037@thunk.org>
	<20071209004017.GQ19691@waste.org>
	<20071209020828.GX17037@thunk.org>
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

> So my personal take on it is that protecting against backtracking
> attacks is mainly useful in silencing academics who like to come up
> with, well, largely academic and theoretical scenario.  If it doesn't
> take much effort, sure, let's try to protect against it (and I think
> we're OK already).

That problem seems to arise here because we have an interface to add
'real' entropy to the pool but not one to add randomness to be used
solely for urandom. If we had both then the user could choose to add some
degree of randomness solely for urandom usage.

Alan
