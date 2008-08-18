Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbYHRV4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbYHRV4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758004AbYHRVz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:55:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33399 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757994AbYHRVz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:55:57 -0400
Date: Mon, 18 Aug 2008 22:38:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Char: cyclades, remove bogus iomap
Message-ID: <20080818223828.29b3adac@lxorguk.ukuu.org.uk>
In-Reply-To: <20080818144438.e3eab97a.akpm@linux-foundation.org>
References: <1218731154-32692-1-git-send-email-jirislaby@gmail.com>
	<20080818144438.e3eab97a.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008 14:44:38 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 14 Aug 2008 18:25:52 +0200
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
> > readl/writel are not expected to accept iomap return value. Replace
> > bogus mapping by standard ioremap.
> 
> Confused.  What's wrong with doing readl(pci_iomap(...))?  There are a
> fair number of drivers doing this..

That was discussed some time ago and we fixed a few then.

There is no guarantee that a platform chooses to implement iomaps such
that an iomap cookie is valid for readl/writel. It happens to work on the
current generic implementation.

Alan
