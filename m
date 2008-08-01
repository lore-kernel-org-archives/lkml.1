Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbYHAWxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbYHAWxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYHAWww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:52:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58489 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751319AbYHAWwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:52:51 -0400
Date: Fri, 1 Aug 2008 23:34:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Elias Oltmanns <eo@nebensachen.de>, Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] libata: Implement disk shock protection support
Message-ID: <20080801233459.11e9b254@lxorguk.ukuu.org.uk>
In-Reply-To: <4892B8FE.1070400@gmail.com>
References: <87prp1kvyy.fsf@denkblock.local>
	<20080726062142.29070.10413.stgit@denkblock.local>
	<4892B8FE.1070400@gmail.com>
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

> However, SATA or not, there simply isn't a way to abort commands in ATA.
>  Issuing random command while other commands are in progress simply is
> state machine violation and there will be many interesting results
> including complete system lockup (ATA controller dying while holding the
> PCI bus).  The only reliable way to abort in-flight commands are by
> issuing hardreset.  However, ATA reset protocol is not designed for
> quick recovery.  The machine is gonna hit the ground hard way before the
> reset protocol is complete.

Actually you cau can issue idle immediate on older ATA devices. I am not
clear if that was stuck back into the current accelerometer friendly
drives or not. Would need to check with IBLenovo

