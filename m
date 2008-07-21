Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbYGUU6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbYGUU6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 16:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYGUU6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 16:58:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60619 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752440AbYGUU6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 16:58:02 -0400
Date: Mon, 21 Jul 2008 21:40:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VT: Restore VT fonts on switch
Message-ID: <20080721214025.32bb2629@lxorguk.ukuu.org.uk>
In-Reply-To: <E1KL0tq-0001Wk-Ny@critter.phunnypharm.org>
References: <E1KL0tq-0001Wk-Ny@critter.phunnypharm.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008 15:39:44 -0400
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> Not all X drivers save and restore fonts on text VTs. Add code to the
> kernel to explicitly save and restore them on VT switches.

Please explain why this cannot be done by HAL.

Please further explain the use of lock_kernel and why you think that is
sufficient and safe.

For bonus points explain how the behaviour of the kmalloc failing is
sufficient.

NAK

Alan
