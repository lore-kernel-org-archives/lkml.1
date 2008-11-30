Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbYK3LQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbYK3LQa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 06:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYK3LQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 06:16:22 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52483 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751203AbYK3LQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 06:16:21 -0500
Date: Sun, 30 Nov 2008 11:16:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Mackerras <paulus@samba.org>
Cc: roel kluin <roel.kluin@gmail.com>, benh@kernel.crashing.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: powerpc: hv{cs, si}_close() both unsigned hp->count and
 hvcsd->open_count cannot be negative
Message-ID: <20081130111614.21b194c5@lxorguk.ukuu.org.uk>
In-Reply-To: <18737.52782.650416.444270@cargo.ozlabs.ibm.com>
References: <4931201D.7060701@gmail.com>
	<18737.52782.650416.444270@cargo.ozlabs.ibm.com>
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

> Also, I don't see why those changes have anything to do with "unsigned
> things cannot be negative".  As long as those counts are never zero on
> entry to those code sections, the existing code is fine, and I believe
> that assertion can be maintained.  If you believe the code needs to
> defend against the possibility of a zero count on entry, that should
> have been explicitly stated in the patch description.

See the tty_port patches in -next - this is an argument about code which
ought eventually to go away replaced by standard helper functions.
