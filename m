Return-Path: <linux-kernel-owner+w=401wt.eu-S1756265AbZAVMkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265AbZAVMkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 07:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754743AbZAVMka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 07:40:30 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35127 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754711AbZAVMk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 07:40:29 -0500
Date: Thu, 22 Jan 2009 12:40:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: bmckinlay@perle.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 60/80] tty: extract the pty init time special cases
Message-ID: <20090122124042.7251ff0f@lxorguk.ukuu.org.uk>
In-Reply-To: <OF87B1346C.1E63B3D8-ON85257546.0006F3DA-85257546.000CF300@perle.com>
References: <OF87B1346C.1E63B3D8-ON85257546.0006F3DA-85257546.000CF300@perle.com>
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

> This patch seems to break any other pseudo tty drivers, (ie driver->type 
> ==TTY_DRIVER_TYPE_PTY) since not all the tty functions needed for the 
> driver's new driver->install method are exported from tty_io.c.  The 
> function symbols that need to be exported from /drivers/char/tty_io.c are 

I did ask at the time what other PTY drivers there were as and
what .config case in the kernel needed those symbols. If you only need
them for an out of tree driver then they can stay out of tree until that
driver is merged.

Alan
