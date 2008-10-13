Return-Path: <linux-kernel-owner+w=401wt.eu-S1762311AbYJMNfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762311AbYJMNfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 09:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759448AbYJMNfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 09:35:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40133 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762164AbYJMNfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 09:35:10 -0400
Date: Mon, 13 Oct 2008 14:35:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: GIT head no longer boots on x86-64
Message-ID: <20081013143502.01f3f526@lxorguk.ukuu.org.uk>
In-Reply-To: <1223895414-19793-1-git-send-email-jirislaby@gmail.com>
References: <20081013112024.0183f982@lxorguk.ukuu.org.uk>
	<1223895414-19793-1-git-send-email-jirislaby@gmail.com>
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

On Mon, 13 Oct 2008 12:56:54 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> Could you try the debug patch below to see what address is text_poke trying
> to translate?


BUG? vmalloc_to_page (from text_poke+0x30/0x14a): ffffffffa01e40b1
BUG? vmalloc_to_page (from text_poke+0x40/0x14a): ffffffffa01e50b1
BUG? vmalloc_to_page (from text_poke+0x30/0x14a): ffffffffa01e40da
BUG? vmalloc_to_page (from text_poke+0x40/0x14a): ffffffffa01e50da
BUG? vmalloc_to_page (from text_poke+0x30/0x14a): ffffffffa01e41eb
BUG? vmalloc_to_page (from text_poke+0x40/0x14a): ffffffffa01e51eb
BUG? vmalloc_to_page (from text_poke+0x30/0x14a): ffffffffa01e4446
BUG? vmalloc_to_page (from text_poke+0x40/0x14a): ffffffffa01e5446
BUG? vmalloc_to_page (from text_poke+0x30/0x14a): ffffffffa01e458d
BUG? vmalloc_to_page (from text_poke+0x40/0x14a): ffffffffa01e558d
BUG? vmalloc_to_page (from text_poke+0x30/0x14a): ffffffffa01e4621
BUG? vmalloc_to_page (from text_poke+0x40/0x14a): ffffffffa01e5621
BUG? vmalloc_to_page (from text_poke+0x30/0x14a): ffffffffa01e49a3
BUG? vmalloc_to_page (from text_poke+0x40/0x14a): ffffffffa01e59a3
BUG? vmalloc_to_page (from text_poke+0x30/0x14a): ffffffffa01e4a21
BUG? vmalloc_to_page (from text_poke+0x40/0x14a): ffffffffa01e5a21
BUG? vmalloc_to_page (from text_poke+0x30/0x14a): ffffffffa01e4a28
BUG? vmalloc_to_page (from text_poke+0x40/0x14a): ffffffffa01e5a28
BUG? vmalloc_to_page (from text_poke+0x30/0x14a): ffffffffa01e4a7a
BUG? vmalloc_to_page (from text_poke+0x40/0x14a): ffffffffa01e5a7a

and lots more
