Return-Path: <linux-kernel-owner+w=401wt.eu-S936446AbYBCHly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936446AbYBCHly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 02:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936257AbYBCHlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 02:41:42 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:37645 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935774AbYBCHll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 02:41:41 -0500
Date: Sun, 3 Feb 2008 08:41:43 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Subject: Re: [patch] scsi: fix spurious build failures in aic7xxx
Message-ID: <20080203074143.GA19981@uranus.ravnborg.org>
References: <20080201225056.GA18302@elte.hu> <20080202135935.GA23838@uranus.ravnborg.org> <20080202140326.GA6544@elte.hu> <20080202140630.GA7939@elte.hu> <20080202141857.GA8635@elte.hu> <20080202162611.GA24765@uranus.ravnborg.org> <20080202171020.GB12748@elte.hu> <20080203045441.GA12128@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203045441.GA12128@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2008 at 05:54:41AM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > I could not reproduce the bug myself but I think I spotted it. We 
> > > had a missing dependency to the _reg.h file. Try following patch and 
> > > let me now if it continue to break.
> > 
> > thanks! I threw this into the test setup and will know by tomorrow 
> > whether there's any breakage.
> 
> good news: hundreds of successful kernel builds and no failures 
> overnight. I've Cc:-ed the aic7xxx people.

Thanks for testing Ingo.

James - I plan to submit this via kbuild.git in about 10 hours.
Let me know if you would like it to go in via scsi and I
will drop you an updated patch (need to elaboarte a bit more in
the commit message).

	Sam
