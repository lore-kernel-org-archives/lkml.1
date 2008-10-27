Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbYJ0SHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbYJ0SHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 14:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbYJ0SH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 14:07:28 -0400
Received: from nn7.de ([85.214.94.156]:47556 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbYJ0SH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 14:07:28 -0400
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
From: Soeren Sonnenburg <kernel@nn7.de>
To: "Rafael J\. Wysocki" <rjw@sisk.pl>
Cc: "Carlos R\. Mafra" <crmafra2@gmail.com>,
       Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       tomas.winkler@intel.com, "John W\. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
In-Reply-To: <200810271832.40717.rjw@sisk.pl>
References: <20081027162054.GA4015@localhost.aei.mpg.de>
	 <200810271832.40717.rjw@sisk.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Oct 2008 19:07:24 +0100
Message-Id: <1225130844.4466.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 18:32 +0100, Rafael J. Wysocki wrote:
> [Added some CCs]
> 
> On Monday, 27 of October 2008, Carlos R. Mafra wrote:
> > Hi,
> > 
> > So I managed to bisect my suspend to RAM regression in 2.6.27-rc2
> > to commit 3b7ee69d0caefbdb85a606a98bff841b8c63b97e ("mac80211: disassociate 
> > when moving to new BSS") by Tomas Winkler (Cc:-ed).
> > 
> > Unfortunately it doesn't revert cleanly so I can't double check it.
> > 
> > My laptop is a Vaio FZ240E Core2Duo@2GHz and I use the iwlagn module
> > for the wireless connection.
> > 
> > The symptom is that suspending to RAM from inside X with 'echo mem >
> > /sys/power/state' leaves me a black screen when resuming back.
> > 
> > I can test any patches and provide more information of my laptop too.
> 
> Carlos, thanks a lot for bisecting this.
> 
> Johannes, can you pls have a look?

Hmmhh, I still have the problem when removing the mac80211 and other
wireless modules before s2ram...

Soeren
