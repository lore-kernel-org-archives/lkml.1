Return-Path: <linux-kernel-owner+w=401wt.eu-S1751441AbZG1KZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbZG1KZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbZG1KZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:25:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53164 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750824AbZG1KZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:25:11 -0400
Date: Tue, 28 Jul 2009 11:26:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>
Subject: Re: linux-next: manual merge of the ttydev tree with the
 usb.current tree
Message-ID: <20090728112608.09a494e0@lxorguk.ukuu.org.uk>
In-Reply-To: <20090728140110.7cfe7c22.sfr@canb.auug.org.au>
References: <20090728140110.7cfe7c22.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009 14:01:10 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Alan,
> 
> Today's linux-next merge of the ttydev tree got a conflict in
> drivers/usb/serial/usb-serial.c between commit
> a00b8d98aca97bfb6fa983f41dae25b424058592 ("USB: fix usage count in usb
> serial generic open regarding autoresume") from the usb.current tree

That looks wrong. The extra fiddling with port.count looks both unsafe
and incorrect. I've never seen the "autoresume" patch referred to so I've
no idea what it is trying to do

Greg ?
