Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbYGIPVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbYGIPVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 11:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbYGIPVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 11:21:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41107 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752195AbYGIPVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 11:21:21 -0400
Date: Wed, 9 Jul 2008 15:46:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, alan@redhat.com,
       Markus.Lidel@shadowconnect.com, vvs@sw.ru, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Mark i2o config broken on 64-bit platforms.
Message-ID: <20080709154649.57f66bb9@the-village.bc.nu>
In-Reply-To: <20080709044743.0dd15a3f.akpm@linux-foundation.org>
References: <20080709113547.19235.15424.stgit@warthog.procyon.org.uk>
	<20080709044743.0dd15a3f.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sigh.  I've been staring at that warning for so long.
> 
> Is it actually known to be broken on 64-bit, or does it happen to work?

64bit kernel 32bit user space should be fine, aside of any DMA allocation
bugs. Actually 'fixing' it would mean adding a new 64bit clean ioctl but
given you only need the config tool very occassionally and I2O is almost
extinct but not quite dead yet nobody has bothered too much.

Alan
