Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbYLJQik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbYLJQik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbYLJQiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:38:15 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36258 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757007AbYLJQiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:38:13 -0500
Date: Wed, 10 Dec 2008 16:38:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Julia Lawall <julia@diku.dk>
Cc: dmitri.vorobiev@movial.fi, gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/28] drivers/base/platform.c: Drop return value from
 platform_driver remove functions
Message-ID: <20081210163819.17cf4628@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0812101725540.21998@ask.diku.dk>
References: <Pine.LNX.4.64.0812101725540.21998@ask.diku.dk>
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

On Wed, 10 Dec 2008 17:26:26 +0100 (CET)
Julia Lawall <julia@diku.dk> wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> The return value of the remove function of a driver structure, and thus of
> a platform_driver structure, is ultimately ignored

Currently

> and is thus unnecessary.

Really - capturing those kind of failures is useful information which is
currently discarded but could later be used. Removing that information
makes it very hard to go and put back into all the drivers.

Alan
