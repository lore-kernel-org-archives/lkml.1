Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbZAEO2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbZAEO2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbZAEO21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:28:27 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50465 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754084AbZAEO20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:28:26 -0500
Date: Mon, 5 Jan 2009 14:28:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Julia Lawall <julia@diku.dk>
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 7/7] drivers/usb/serial: Move a dereference below a NULL
 test
Message-ID: <20090105142841.1dc7f32d@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0812260829000.25450@ask.diku.dk>
References: <Pine.LNX.4.64.0812260829000.25450@ask.diku.dk>
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

On Fri, 26 Dec 2008 08:29:19 +0100 (CET)
Julia Lawall <julia@diku.dk> wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> If the NULL test is necessary, then the dereference should be moved below
> the NULL test.

Both serial ones reviewed and the NULL test removed entirely
