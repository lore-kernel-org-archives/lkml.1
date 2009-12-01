Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbZLAS6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbZLAS6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 13:58:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbZLAS6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 13:58:06 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57458 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751917AbZLAS6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 13:58:04 -0500
Date: Tue, 1 Dec 2009 19:00:10 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: divide by zero in termios when setting bluetooth
Message-ID: <20091201190010.317d5b29@lxorguk.ukuu.org.uk>
In-Reply-To: <20091201160151.GD2262@elf.ucw.cz>
References: <20091201151315.GC2262@elf.ucw.cz>
	<20091201155244.0523d9c9@lxorguk.ukuu.org.uk>
	<20091201160151.GD2262@elf.ucw.cz>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	/* Should never happen */
> > +	WARN_ON(1);
> >  	return 0;
> 
> Does this mean WARN_ON() on user error? Maybe printk(KERN_ERR) with
> explanation would be better?

It shouldn't be possible to cause that case user error or otherwise.

