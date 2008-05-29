Return-Path: <linux-kernel-owner+w=401wt.eu-S1758528AbYE2S0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528AbYE2S0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbYE2S0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:26:07 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47869 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbYE2S0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:26:06 -0400
Message-ID: <483EF536.90801@garzik.org>
Date: Thu, 29 May 2008 14:25:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: RESEND: [PATCH] libata-sff: Fix oops reported in kerneloops.org
 for pnp devices with no ctl
References: <20080529161453.24735.805.stgit@core>	<alpine.LFD.1.10.0805290950230.2958@woody.linux-foundation.org> <20080529190235.258d304e@core>
In-Reply-To: <20080529190235.258d304e@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> maybe_altstatus is crap naming but simply making ata_sff_altstatus fake a
> reply in arbitary cases risks not catching mistakes and could mean we
> don't catch corrupting mistakes which would be very bad indeed.

Please grep the remaining users, IMO you will find that's not really 
true.  After your patch no core users remain, only ones in a few 
scattered drivers that most likely want your logic (or a 
simplified-for-that-controller version thereof).

	Jeff


