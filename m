Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbYJFP31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbYJFP31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 11:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbYJFP3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 11:29:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56733 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751633AbYJFP3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 11:29:18 -0400
Date: Mon, 6 Oct 2008 16:29:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: RFC: banning device driver reserved resources from /dev/mem
Message-ID: <20081006162914.4f140938@lxorguk.ukuu.org.uk>
In-Reply-To: <20081006075738.318a983f@infradead.org>
References: <20081005180154.7cc12486@infradead.org>
	<20081006102739.16d1a434@lxorguk.ukuu.org.uk>
	<48EA1540.8060409@gmail.com>
	<20081006144835.6e58f73a@lxorguk.ukuu.org.uk>
	<20081006065213.76dc729a@infradead.org>
	<20081006150122.3860cae1@lxorguk.ukuu.org.uk>
	<20081006070543.23b14828@infradead.org>
	<20081006151411.05ed5f50@lxorguk.ukuu.org.uk>
	<20081006072437.5d1360dd@infradead.org>
	<20081006153825.66e50770@lxorguk.ukuu.org.uk>
	<20081006075738.318a983f@infradead.org>
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

On Mon, 6 Oct 2008 07:57:38 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> > 
> > For debug tools that would be almost all drivers, and for distribution
> > use that needs to be a runtime selection.
> 
> is boottime (read: kernel parameter) ok ?
> it would totally make sense to have a kernel boot parameter that
> disables all /dev/mem sanity checks.

A boot parameter probably catches most cases yes.

> that's a hard case but probably not the most interesting case; drivers
> get loaded early thankfully.
> (yes revoke is hard ;( )

Yeah .. I was hoping you'd write it ;)
