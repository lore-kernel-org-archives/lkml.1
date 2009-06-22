Return-Path: <linux-kernel-owner+w=401wt.eu-S1756342AbZFVMgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbZFVMgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 08:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbZFVMf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 08:35:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56895 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756184AbZFVMf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 08:35:58 -0400
Date: Mon, 22 Jun 2009 13:36:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Rabin Vincent <rabin@rab.in>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: BUG: scheduling while atomic
Message-ID: <20090622133612.22fd84b8@lxorguk.ukuu.org.uk>
In-Reply-To: <20090622113308.GA32155@localdomain.by>
References: <20090619181529.GA3593@localdomain.by>
	<20090620174320.GA6791@debian>
	<20090620185452.GD3138@localdomain.by>
	<20090622105721.262179f9@lxorguk.ukuu.org.uk>
	<20090622113308.GA32155@localdomain.by>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009 14:33:08 +0300
Sergey Senozhatsky <sergey.senozhatsky@mail.by> wrote:

> On (06/22/09 10:57), Alan Cox wrote:
> > 
> > Fix on its way upstream.
> > 
> 
> Alan, can you send me patch so I can test it?

Just delete the tty_unthrottle() from drivers/net/ppp/ppp_async.c - it
never throttles the port so it never needs to unthrottle it (which is why
it happened never to cause crashes before)
