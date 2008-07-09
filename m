Return-Path: <linux-kernel-owner+w=401wt.eu-S1757713AbYGIPVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713AbYGIPVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 11:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbYGIPVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 11:21:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41108 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753583AbYGIPVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 11:21:23 -0400
Date: Wed, 9 Jul 2008 15:47:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: alan@redhat.com, Markus.Lidel@shadowconnect.com, vvs@sw.ru,
       akpm@linux-foundation.org, dhowells@redhat.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Mark i2o config broken on 64-bit platforms.
Message-ID: <20080709154753.3dcfacab@the-village.bc.nu>
In-Reply-To: <20080709113547.19235.15424.stgit@warthog.procyon.org.uk>
References: <20080709113547.19235.15424.stgit@warthog.procyon.org.uk>
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

On Wed, 09 Jul 2008 12:35:47 +0100
David Howells <dhowells@redhat.com> wrote:

> Mark i2o config broken on 64-bit platforms as it generates these:
> 
> In file included from drivers/message/i2o/config-osm.c:39:
> drivers/message/i2o/i2o_config.c: In function 'i2o_cfg_passthru':
> drivers/message/i2o/i2o_config.c:889: warning: cast to pointer from integer of different size
> drivers/message/i2o/i2o_config.c:945: warning: cast to pointer from integer of different size
> 
> which are apparently non-trivial to fix (eg: inserting a cast through unsigned
> long is not correct according to Linus).  This would be due to struct
> sg_simple_element only having a 32-bit addr_bus value.
> 
> There are also a number of "TODO 64bit fix" comments.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>


NAK - it appears to be broken for 64bit user space only
