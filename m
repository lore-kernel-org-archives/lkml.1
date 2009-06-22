Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbZFVJ5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbZFVJ5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 05:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbZFVJ5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 05:57:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38581 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750780AbZFVJ5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 05:57:17 -0400
Date: Mon, 22 Jun 2009 10:57:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Rabin Vincent <rabin@rab.in>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: BUG: scheduling while atomic
Message-ID: <20090622105721.262179f9@lxorguk.ukuu.org.uk>
In-Reply-To: <20090620185452.GD3138@localdomain.by>
References: <20090619181529.GA3593@localdomain.by>
	<20090620174320.GA6791@debian>
	<20090620185452.GD3138@localdomain.by>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Jun 2009 21:54:52 +0300
Sergey Senozhatsky <sergey.senozhatsky@mail.by> wrote:

> On (06/20/09 23:13), Rabin Vincent wrote:
> > On Fri, Jun 19, 2009 at 09:15:29PM +0300, Sergey Senozhatsky wrote:
> > > Hello.
> > > I see lots of "BUG: scheduling while atomic" with current kernels (started with 2.6.30-git1, 2.6.30 is ok).
> > > For example (2.6.30-git14):
> > 
> > Looks like the net softirq (via ppp) ends up calling tty_throttle(), and
> > this causes problems because of the mutex_lock() added there by
> > 38db8979.  I've cc'd the tty maintainer.

Fix on its way upstream.
