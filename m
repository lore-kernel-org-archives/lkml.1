Return-Path: <linux-kernel-owner+w=401wt.eu-S1757127AbXI0ScF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127AbXI0ScF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 14:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbXI0Sby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 14:31:54 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38498 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753797AbXI0Sbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 14:31:52 -0400
Date: Thu, 27 Sep 2007 19:37:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Mark Lord <liml@rtr.ca>, Andrew Morton <akpm@linux-foundation.org>,
       michal.k.k.piotrowski@gmail.com, bryan@arbores.ca,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Stardom SATA HSM violation
Message-ID: <20070927193701.6230d77f@the-village.bc.nu>
In-Reply-To: <46FB563A.80108@gmail.com>
References: <46CFA08E.6090604@arbores.ca>
	<6bffcb0e0708261610g10d9c59ck5789fac6feca9f42@mail.gmail.com>
	<46DBCB6C.8080206@gmail.com>
	<20070905095327.6277d054.akpm@linux-foundation.org>
	<46DEE617.4050004@rtr.ca>
	<46E0A253.7060803@gmail.com>
	<46E154DE.2060602@rtr.ca>
	<46FB563A.80108@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I think there have been enough cases where this draining was necessary.
>  IIRC, ata_piix was involved in those cases, right?  If so, can you
> please submit a patch which applies this only to affected controllers?
> I don't feel too confident about applying this to all SFF controllers.

Old IDE does it on all controllers bar a couple. So we have a very good
knowledge of what does/doesn't work. The one that needs care in old ide
is an ordering issue where a state machine reset done first causes the
drain of the I/O to hang.
