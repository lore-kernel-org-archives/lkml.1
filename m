Return-Path: <linux-kernel-owner+w=401wt.eu-S1758237AbXFMNFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237AbXFMNFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 09:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757576AbXFMNFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 09:05:08 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47777 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756886AbXFMNFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 09:05:05 -0400
Date: Wed, 13 Jun 2007 15:04:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: James Ketrenos <jketreno@linux.intel.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: Re: ipw3945 driver in recent -mm kernels
Message-ID: <20070613130458.GB2390@elf.ucw.cz>
References: <20070609192703.GA6410@elf.ucw.cz> <20070609215712.GA13678@elf.ucw.cz> <466DA14D.6080309@linux.intel.com> <20070613110718.GA1800@elf.ucw.cz> <466FEA7B.3000101@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466FEA7B.3000101@lwfinger.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2007-06-13 08:00:43, Larry Finger wrote:
> Pavel Machek wrote:
> >Hi!
> >
> >BTW could we get some more reasonable path? Currently wifi drivers are
> >in
> >
> >drivers/net/wireless/mac80211/iwlwifi
> >
> >...ouch. drivers/mac80211/iwlwifi would be better...
> 
> NACK. Having _ALL_ wireless drivers under drivers/net/wireless/ is correct. 
> I would vote, however, for collapsing out the mac80211 directory once all 
> softmac drivers are converted to mac80211 and all the duplications are 
> removed.

Anything that makes it less deep is good idea.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
