Return-Path: <linux-kernel-owner+w=401wt.eu-S1752070AbXCHO7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbXCHO7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 09:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbXCHO7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 09:59:24 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42209 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752059AbXCHO7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 09:59:23 -0500
Date: Thu, 8 Mar 2007 16:03:03 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] tty: Turn on arbitary baud rate ioctls for i386
 platform
Message-ID: <20070308160303.20521cb8@lxorguk.ukuu.org.uk>
In-Reply-To: <1173364787.4568.0.camel@laptopd505.fenrus.org>
References: <20070308144445.31a4e3c4@lxorguk.ukuu.org.uk>
	<1173364787.4568.0.camel@laptopd505.fenrus.org>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Mar 2007 06:39:47 -0800
Arjan van de Ven <arjan@infradead.org> wrote:

> On Thu, 2007-03-08 at 14:44 +0000, Alan Cox wrote:
> > Adds the needed TCGETS2/TCSETS2 ioctl calls, structures, defines and the
> > like. Tested against the test suite and passes. Other platforms should need
> > roughly the same change.
> 
> 
> should this then really be in include/asm/* ? If everyone needs the same
> change I'd think it should go into include/linux/* somewhere.

It should be in include/asm. There are a whole range of different
variations of the structures and ioctl numbering in use on different
platforms so it does not trivially unify alas.

Alan
