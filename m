Return-Path: <linux-kernel-owner+w=401wt.eu-S1752376AbYLCPe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbYLCPe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 10:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYLCPeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 10:34:17 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47724 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751098AbYLCPeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 10:34:17 -0500
Date: Wed, 3 Dec 2008 15:33:51 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] Char: n_tty, include module.h
Message-ID: <20081203153351.1a1c054c@lxorguk.ukuu.org.uk>
In-Reply-To: <4936A320.3050801@gmail.com>
References: <1228307338-18467-1-git-send-email-jirislaby@gmail.com>
	<20081203124300.3f03dec8@lxorguk.ukuu.org.uk>
	<4936A320.3050801@gmail.com>
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

On Wed, 03 Dec 2008 16:17:52 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> On 12/03/2008 01:43 PM, Alan Cox wrote:
> > On Wed,  3 Dec 2008 13:28:58 +0100
> > Jiri Slaby <jirislaby@gmail.com> wrote:
> > 
> >> Since we are using EXPORT_SYMBOL, we should include linux/module.h
> >>
> >> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> > 
> > NAK
> > 
> > n_tty doesn't use EXPORT_SYMBOL.
> 
> Sure it does. Maybe the patch didn't come to you yet. Will repost to akpm as a
> ldisc-n_tty-export-all-n_tty-ldisc-methods.patch fix

And that patch isn't going in either. Ask Andrew to drop it instead. If
the rest of the PPS stuff goes in then I'll redo that part of the n_tty
stuff differently and cleanly.

Alan
