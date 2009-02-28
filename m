Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbZB1K7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbZB1K7o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 05:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbZB1K7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 05:59:35 -0500
Received: from mail.openmoko.org ([88.198.124.205]:52586 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbZB1K7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 05:59:35 -0500
Date: Sat, 28 Feb 2009 16:29:09 +0530
From: Balaji Rao <balajirrao@openmoko.org>
To: Simon Kagstrom <simon.kagstrom@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andy Green <andy@openmoko.com>, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 2/2] spi_bitbang: Add support for non-blocking
	synchronous transfers
Message-ID: <20090228105908.GA3150@fedora.yogi>
References: <20090228081036.31964.80618.stgit@fedora.yogi> <20090228081117.31964.51155.stgit@fedora.yogi> <20090228100914.2ec2ff7f@lska2> <20090228095846.GA32044@fedora.yogi> <20090228111524.1594a58e@lska2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090228111524.1594a58e@lska2>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 11:15:24AM +0100, Simon Kagstrom wrote:
> On Sat, 28 Feb 2009 15:28:48 +0530
> Balaji Rao <balajirrao@openmoko.org> wrote:
> 
> > The master is not spi_s3c24xx but spi_s3x24xx_gpio, whose txrx are
> > very simple code.
> > 
> > Additionally all of this has been tested and found to work. The code,
> > along with the modified new spi based lis302dl driver is all in
> > andy-tracking [1].
> 
> Oh, I didn't notice that. Nice then.
> 
> I see from the git logs that this and some other related patches have
> been added now. Another question I have then is about the name: to me 
> spi_non_blocking_transfer() sounds like it would do the opposite of
> what I guess it does - it would go ahead without blocking on the call.
> 

Yes, isn't that what it's supposed to do ? It's going to complete
without putting current to sleep.

> I guess what the name means is that it will not sleep during the call,
> but for pushing it upstream, could it be better to name it something
> else? Perhaps spi_sync and then rename the existing API name (which I
> think is more than a bit strange), or maybe spi_sync_nowait or
> something?

Yes, even I was not terribly happy with 'non_blocking_transfer'.
But I recommend against changing the behaviour of existing functions.
spi_sync_nowait seems good though. 

I hope to get more comments soon. Let's see what other people have to
say.

Thanks,
Balaji
