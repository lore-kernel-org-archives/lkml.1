Return-Path: <linux-kernel-owner+w=401wt.eu-S933142AbXJRIvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142AbXJRIvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 04:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932584AbXJRIvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 04:51:35 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44223 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932592AbXJRIve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 04:51:34 -0400
Message-ID: <47171E87.9070502@garzik.org>
Date: Thu, 18 Oct 2007 04:51:19 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
References: <20071017172932.GI15552@kernel.dk> <20071017173408.GA1960@elte.hu> <20071017174503.GA4622@elte.hu> <20071017175337.GN15552@kernel.dk> <20071017183716.GU15552@kernel.dk> <20071017190901.GA13780@elte.hu> <alpine.LFD.0.999.0710171217160.26902@woody.linux-foundation.org> <20071017193542.GA15552@kernel.dk> <20071018070706.GA7435@elte.hu> <471717BF.4030108@pobox.com> <20071018083213.GN5063@kernel.dk> <47171B78.9060901@garzik.org>
In-Reply-To: <47171B78.9060901@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> I noticed that 
> sg_tablesize in sata_mv is not LIBATA_MAX_PRD.  This is expected 
> behavior, but I wonder if that difference -- most notably being smaller 
> than SCSI_MAX_SG_SEGMENTS -- would trigger any latent bugs.

Another sata_mv difference from the rest: the chip does not support 
ATAPI, so we never care about qc->pad

	Jeff


