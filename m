Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbYJ0R2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbYJ0R2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 13:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYJ0R2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 13:28:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59754 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbYJ0R2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 13:28:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Carlos R. Mafra" <crmafra2@gmail.com>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
Date: Mon, 27 Oct 2008 18:32:39 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, tomas.winkler@intel.com, kernel@nn7.de,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
References: <20081027162054.GA4015@localhost.aei.mpg.de>
In-Reply-To: <20081027162054.GA4015@localhost.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810271832.40717.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added some CCs]

On Monday, 27 of October 2008, Carlos R. Mafra wrote:
> Hi,
> 
> So I managed to bisect my suspend to RAM regression in 2.6.27-rc2
> to commit 3b7ee69d0caefbdb85a606a98bff841b8c63b97e ("mac80211: disassociate 
> when moving to new BSS") by Tomas Winkler (Cc:-ed).
> 
> Unfortunately it doesn't revert cleanly so I can't double check it.
> 
> My laptop is a Vaio FZ240E Core2Duo@2GHz and I use the iwlagn module
> for the wireless connection.
> 
> The symptom is that suspending to RAM from inside X with 'echo mem >
> /sys/power/state' leaves me a black screen when resuming back.
> 
> I can test any patches and provide more information of my laptop too.

Carlos, thanks a lot for bisecting this.

Johannes, can you pls have a look?

Thanks,
Rafael
