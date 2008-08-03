Return-Path: <linux-kernel-owner+w=401wt.eu-S1757790AbYHCNXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790AbYHCNXn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 09:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757471AbYHCNX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 09:23:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51108 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757434AbYHCNX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 09:23:27 -0400
Date: Sun, 3 Aug 2008 14:05:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Elias Oltmanns <eo@nebensachen.de>, Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] libata: Implement disk shock protection support
Message-ID: <20080803140536.062c2ef1@lxorguk.ukuu.org.uk>
In-Reply-To: <489523DC.2090903@gmail.com>
References: <87prp1kvyy.fsf@denkblock.local>
	<20080726062142.29070.10413.stgit@denkblock.local>
	<4892B8FE.1070400@gmail.com>
	<20080801233459.11e9b254@lxorguk.ukuu.org.uk>
	<489523DC.2090903@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Was that something intentional or was it a happy accident?  There can be
> bus ownership problem on PATA and on SATA this is much more state logic

IDLE IMMEDIATE is part of the "historic" specification rather than modern
ATA standards. Older drives support it happily newer ones tended to get
quite cross.

> on both sides of the cable and I think things like that would be more
> difficult to work accidentally.

We'd have to query the drive vendors to see what they expected.

