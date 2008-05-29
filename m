Return-Path: <linux-kernel-owner+w=401wt.eu-S1758636AbYE2Tb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636AbYE2Tb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 15:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbYE2Tbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 15:31:48 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42545 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbYE2Tbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 15:31:47 -0400
Message-ID: <483F049E.2090809@garzik.org>
Date: Thu, 29 May 2008 15:31:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: RESEND: [PATCH] libata-sff: Fix oops reported in kerneloops.org
 for pnp devices with no ctl
References: <20080529161453.24735.805.stgit@core>	<alpine.LFD.1.10.0805290950230.2958@woody.linux-foundation.org>	<20080529190235.258d304e@core>	<483EF536.90801@garzik.org> <20080529194238.36458a46@core>
In-Reply-To: <20080529194238.36458a46@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Please grep the remaining users, IMO you will find that's not really 
>> true.  After your patch no core users remain, only ones in a few 
>> scattered drivers that most likely want your logic (or a 
>> simplified-for-that-controller version thereof).
> 
> That said if you want to be clearer we can hide the altstatus function
> internally and only export an ata_sff_dma_sync() which does go *BANG* if
> you call it with no altstatus (where you would immediately violate DMA
> timing rules)
> 
> Want me to roll a patch in that style ?

Works for me...


