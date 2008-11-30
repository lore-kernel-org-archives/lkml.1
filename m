Return-Path: <linux-kernel-owner+w=401wt.eu-S1756394AbYK3V1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbYK3V1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 16:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbYK3V1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 16:27:03 -0500
Received: from ozlabs.org ([203.10.76.45]:43545 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064AbYK3V1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 16:27:01 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18739.1091.452314.941676@cargo.ozlabs.ibm.com>
Date: Mon, 1 Dec 2008 08:23:15 +1100
From: Paul Mackerras <paulus@samba.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: roel kluin <roel.kluin@gmail.com>, benh@kernel.crashing.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: powerpc: hv{cs, si}_close() both unsigned hp->count and
 hvcsd->open_count cannot be negative
In-Reply-To: <20081130111614.21b194c5@lxorguk.ukuu.org.uk>
References: <4931201D.7060701@gmail.com>
	<18737.52782.650416.444270@cargo.ozlabs.ibm.com>
	<20081130111614.21b194c5@lxorguk.ukuu.org.uk>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox writes:

> See the tty_port patches in -next - this is an argument about code which
> ought eventually to go away replaced by standard helper functions.

OK.  In that case I think the best fix for the existing code is just
to change the count to be int rather than unsigned int.

Paul.
