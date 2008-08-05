Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbYHECcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbYHECcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 22:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbYHECcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 22:32:22 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4482 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577AbYHECcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 22:32:21 -0400
Date: Mon, 4 Aug 2008 22:17:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-08-04
Message-ID: <20080805021710.GA21731@tuxdriver.com>
References: <20080804193753.GA30345@tuxdriver.com> <20080804.150147.78586437.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804.150147.78586437.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 03:01:47PM -0700, David Miller wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Mon, 4 Aug 2008 15:37:53 -0400
> 
> > Another big round of fixes for 2.6.27.  Included is also a renaming
> > patch and some related patches that rename iwl4965 to iwlagn (reflecting
> > that is supports iwl5000 as well).
> > 
> > The other big(ger) thing here is the new ath9k driver.  It is probably
> > still far from perfect, but I'm hearing good reports on its
> > functionality and the Atheros team (and others) have already been quite
> > responsive on comments, etc.  I think it is best to go ahead and get it
> > into 2.6.27.
> > 
> > Please let me know if there are problems!
> 
> I'm holding off on this pull until the list.h changes get so me lkml
> ACKs.

Sure, np.  I created a "no-ath9k" branch in case you are feeling
frisky -- it is the same except for omitting the list.h changes,
the ath5k pci table change, and the new ath9k driver.

	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git no-ath9k

Hth!

John
-- 
John W. Linville
linville@tuxdriver.com
