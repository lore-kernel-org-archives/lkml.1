Return-Path: <linux-kernel-owner+w=401wt.eu-S1764717AbXJRLFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764717AbXJRLFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 07:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761271AbXJRLFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 07:05:38 -0400
Received: from brick.kernel.dk ([87.55.233.238]:14963 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761339AbXJRLFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 07:05:38 -0400
Date: Thu, 18 Oct 2007 13:05:00 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071018110500.GV5063@kernel.dk>
References: <20071017172932.GI15552@kernel.dk> <20071017173408.GA1960@elte.hu> <20071017174503.GA4622@elte.hu> <20071017175337.GN15552@kernel.dk> <20071017183716.GU15552@kernel.dk> <20071017190901.GA13780@elte.hu> <alpine.LFD.0.999.0710171217160.26902@woody.linux-foundation.org> <20071017193542.GA15552@kernel.dk> <20071018070706.GA7435@elte.hu> <20071018110306.GA14472@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018110306.GA14472@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18 2007, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > -#define SCSI_MAX_SG_SEGMENTS	128
> > > +#define SCSI_MAX_SG_SEGMENTS	129
> > 
> > this one finally made the trick and it's booting fine now, without any 
> > crashes!
> 
> hm, spoke too soon - i just got the ata_qc_issue() crash below. I've 
> attached further below the current fixes/workarounds that i have applied 
> at the moment. Any ideas?

Hang on Ingo, will post an updated patch soonish!

-- 
Jens Axboe

