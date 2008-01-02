Return-Path: <linux-kernel-owner+w=401wt.eu-S1759500AbYABUug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500AbYABUug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:50:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756426AbYABUuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:50:18 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51832 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753437AbYABUuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:50:16 -0500
Date: Wed, 2 Jan 2008 20:40:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andreas Dilger <adilger@sun.com>
Cc: Adrian Bunk <bunk@kernel.org>, sct@redhat.com, akpm@linux-foundation.org,
       adilger@clusterfs.com, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] let EXT4DEV_FS depend on BROKEN
Message-ID: <20080102204034.703ebdd3@the-village.bc.nu>
In-Reply-To: <20080102174157.GD3351@webber.adilger.int>
References: <20080102013218.GO27566@does.not.exist>
	<20080102174157.GD3351@webber.adilger.int>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jan 2008 10:41:57 -0700
Andreas Dilger <adilger@sun.com> wrote:

> On Jan 02, 2008  03:32 +0200, Adrian Bunk wrote:
> > It might make sense to offer ext4 in -mm and even in early -rc kernels, 
> > but I've already seen people using ext4 simply because a stable kernel 
> > offered it - and that's definitely not intended.
> > 
> > Anyone who _really_ wants to test ext4 should anyway be able to do the 
> > trivial change of removing the "depends on BROKEN" line.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> > @@ -138,7 +138,7 @@ config EXT3_FS_SECURITY
> >  
> >  config EXT4DEV_FS
> >  	tristate "Ext4dev/ext4 extended fs support development (EXPERIMENTAL)"
> > -	depends on EXPERIMENTAL
> > +	depends on BROKEN
> >  	select JBD2
> >  	select CRC16
> >  	help
> 
> Isn't CONFIG_EXPERIMENTAL enough?

Of course it is - Adrian is however trying to remove CONFIG_EXPERIMENTAL
and reality is getting in his way again 
