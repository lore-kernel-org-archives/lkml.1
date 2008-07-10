Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbYGJJEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbYGJJEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 05:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbYGJJEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 05:04:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48936 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752311AbYGJJEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 05:04:15 -0400
Date: Thu, 10 Jul 2008 09:31:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Martin Sustrik <sustrik@fastmq.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Martin Lucina <mato@kotelna.sk>,
       linux-kernel@vger.kernel.org
Subject: Re: Higher than expected disk write(2) latency
Message-ID: <20080710093109.46db7c40@the-village.bc.nu>
In-Reply-To: <4875C45C.2010901@fastmq.com>
References: <20080628121131.GA14181@nodbug.moloch.sk>
	<20080709222701.8eab4924.akpm@linux-foundation.org>
	<4875C45C.2010901@fastmq.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What we see is that AIO performs rather bad while we are still 
> enqueueing more writes (it misses right position on the disk and has to 
> do superfluous disk revolvings), however, once we stop enqueueing new 
> write request, those already in the queue are processed swiftly.

Which disk scheduler are you using - some of the disk schedulers
intentionally delay writes to try and get better block merging.

Alan
