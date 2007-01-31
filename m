Return-Path: <linux-kernel-owner+w=401wt.eu-S933170AbXAaMhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170AbXAaMhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 07:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933146AbXAaMhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 07:37:22 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43221 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933170AbXAaMhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 07:37:22 -0500
Date: Wed, 31 Jan 2007 12:49:33 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070131124933.6b32c4ff@localhost.localdomain>
In-Reply-To: <20070131040212.6057239B568@muan.mtu.ru>
References: <20070130012904.GA9617@kroah.com>
	<ada8xfks90x.fsf@cisco.com>
	<20070130191020.GF20642@kroah.com>
	<adaodogqpmx.fsf@cisco.com>
	<45BFA087.6020905@garzik.org>
	<loom.20070130T231421-484@post.gmane.org>
	<45BFC9EF.4060506@garzik.org>
	<20070131040212.6057239B568@muan.mtu.ru>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, I have a long standing issue with pata_ali not detecting CD-ROM in DMA
> mode. When I rarely watch DVD I rather boot into legacy IDE kernel ...

There is a general problem with some ATAPI devices and the probe logic
currently. The old IDE code has some workarounds that the new libata
layer doesn't yet do.

Alan
