Return-Path: <linux-kernel-owner+w=401wt.eu-S1759848AbYLLSWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848AbYLLSWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 13:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758693AbYLLSWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 13:22:11 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38016 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758376AbYLLSWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 13:22:09 -0500
Date: Fri, 12 Dec 2008 18:21:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Gerd Hoffmann <kraxel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH v2] Add preadv and pwritev system calls.
Message-ID: <20081212182142.46dcf220@lxorguk.ukuu.org.uk>
In-Reply-To: <20081212170347.GR26095@parisc-linux.org>
References: <1229090440-32120-1-git-send-email-kraxel@redhat.com>
	<20081212152929.GM26095@parisc-linux.org>
	<494287D4.2070909@redhat.com>
	<20081212155113.GO26095@parisc-linux.org>
	<49428AFD.5090009@redhat.com>
	<20081212170347.GR26095@parisc-linux.org>
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

On Fri, 12 Dec 2008 10:03:47 -0700
Matthew Wilcox <matthew@wil.cx> wrote:

> On Fri, Dec 12, 2008 at 05:02:05PM +0100, Gerd Hoffmann wrote:
> > I'd *really* hate it to have the same system call with different
> > argument ordering on different systems though.  Especially when swapping
> > two integer values, so gcc wouldn't error out on wrong usage.
> 
> We can always permute it further:
> 
> int fd, int vlen, loff_t pos, const struct *

Or you could add cobol calling syntax or pass the arguments in XML
format ?

Any particular reason you want to make things hell for programmers and
the standard people. Follow the BSD one at least to user space. Anything
else will just lead to pain and suffering later on the standardisation
front.

Alan
