Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbXFMNX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbXFMNX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 09:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbXFMNXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 09:23:48 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:35634
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbXFMNXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 09:23:47 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: ipw3945 driver in recent -mm kernels
Date: Wed, 13 Jun 2007 15:22:56 +0200
User-Agent: KMail/1.9.6
Cc: Pavel Machek <pavel@ucw.cz>, James Ketrenos <jketreno@linux.intel.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
References: <20070609192703.GA6410@elf.ucw.cz> <20070613110718.GA1800@elf.ucw.cz> <466FEA7B.3000101@lwfinger.net>
In-Reply-To: <466FEA7B.3000101@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706131522.56559.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 June 2007 15:00:43 Larry Finger wrote:
> Pavel Machek wrote:
> > Hi!
> > 
> > BTW could we get some more reasonable path? Currently wifi drivers are
> > in
> > 
> > drivers/net/wireless/mac80211/iwlwifi
> > 
> > ...ouch. drivers/mac80211/iwlwifi would be better...
> 
> NACK. Having _ALL_ wireless drivers under drivers/net/wireless/ is correct. I would vote, however, 
> for collapsing out the mac80211 directory once all softmac drivers are converted to mac80211 and all 
> the duplications are removed.

It's gonna happen exactly that way.
We discussed that at the DTL Wireless Summit 2006.

-- 
Greetings Michael.
