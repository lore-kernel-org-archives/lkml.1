Return-Path: <linux-kernel-owner+w=401wt.eu-S1757913AbXFMNZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913AbXFMNZP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 09:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbXFMNZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 09:25:04 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2850 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167AbXFMNZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 09:25:02 -0400
Date: Wed, 13 Jun 2007 08:56:00 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: James Ketrenos <jketreno@linux.intel.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: Re: ipw3945 driver in recent -mm kernels
Message-ID: <20070613125559.GA5576@tuxdriver.com>
References: <20070609192703.GA6410@elf.ucw.cz> <20070609215712.GA13678@elf.ucw.cz> <466DA14D.6080309@linux.intel.com> <20070613110718.GA1800@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070613110718.GA1800@elf.ucw.cz>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 01:07:18PM +0200, Pavel Machek wrote:
> Hi!
> 
> BTW could we get some more reasonable path? Currently wifi drivers are
> in
> 
> drivers/net/wireless/mac80211/iwlwifi
> 
> ...ouch. drivers/mac80211/iwlwifi would be better...

Since -mm is pulling from wireless-dev, the current path matches the
other mac80211-based drivers.

For upstream probably drivers/net/wireless/iwlwifi or even just
drivers/net/wireless...  I have no objection to moving it in
wireless-dev either.

John
-- 
John W. Linville
linville@tuxdriver.com
