Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbXFMNA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbXFMNA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 09:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756736AbXFMNAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 09:00:49 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:40932 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756886AbXFMNAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 09:00:48 -0400
Message-ID: <466FEA7B.3000101@lwfinger.net>
Date: Wed, 13 Jun 2007 08:00:43 -0500
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: James Ketrenos <jketreno@linux.intel.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: Re: ipw3945 driver in recent -mm kernels
References: <20070609192703.GA6410@elf.ucw.cz> <20070609215712.GA13678@elf.ucw.cz> <466DA14D.6080309@linux.intel.com> <20070613110718.GA1800@elf.ucw.cz>
In-Reply-To: <20070613110718.GA1800@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
> BTW could we get some more reasonable path? Currently wifi drivers are
> in
> 
> drivers/net/wireless/mac80211/iwlwifi
> 
> ...ouch. drivers/mac80211/iwlwifi would be better...

NACK. Having _ALL_ wireless drivers under drivers/net/wireless/ is correct. I would vote, however, 
for collapsing out the mac80211 directory once all softmac drivers are converted to mac80211 and all 
the duplications are removed.

Larry


