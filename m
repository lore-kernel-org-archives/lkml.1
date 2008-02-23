Return-Path: <linux-kernel-owner+w=401wt.eu-S933258AbYBWKho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258AbYBWKho (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 05:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbYBWKhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 05:37:37 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60584 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753858AbYBWKhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 05:37:36 -0500
Date: Sat, 23 Feb 2008 10:27:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amiserial: Prepare for locking relaxation in caller.
Message-ID: <20080223102758.0d42ccb3@core>
In-Reply-To: <20080223000525.19ed29ba.akpm@linux-foundation.org>
References: <20080220201101.6fff0c59@core>
	<20080223000525.19ed29ba.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2008 00:05:25 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 20 Feb 2008 20:11:01 +0000 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > 
> > Just wrap this one in a lock_kernel. As I understand it there is no M68K
> > SMP anyway.
> > 
> 
> I assume that all the bkl/locking patches are prerequisites for
> tty-bkl-pushdown.patch, and that they don't depend upon
> tty-bkl-pushdown.patch?

They are all prequisites for some changes I've yet to send you and will
do once I'm sure I've not upset anything in the meantime. There should be
no interdependancies although I've obviously not tested every possible
combination

Alan
