Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbZCPMDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbZCPMDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 08:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbZCPMDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 08:03:16 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:56481 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbZCPMDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 08:03:15 -0400
Date: Mon, 16 Mar 2009 13:03:12 +0100
From: Andreas Mohr <andi@lisas.de>
To: Andreas Mohr <andi@lisas.de>
Cc: Takashi Iwai <tiwai@suse.de>, Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [alsa-devel] Bugs on aspire one A150
Message-ID: <20090316120312.GA19299@rhlx01.hs-esslingen.de>
References: <20081109151323.GA18705@rhlx01.hs-esslingen.de> <s5h7i7c916e.wl%tiwai@suse.de> <20081109200929.GA29333@rhlx01.hs-esslingen.de> <s5hiqqtkxqr.wl%tiwai@suse.de> <491B0D38.1050207@gmail.com> <20081112180519.GA21919@rhlx01.hs-esslingen.de> <491DBDEA.9010104@gmail.com> <492856C2.8000707@gmail.com> <s5hy6z9i44h.wl%tiwai@suse.de> <20090315092117.GA1567@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090315092117.GA1567@rhlx01.hs-esslingen.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Mar 15, 2009 at 10:21:17AM +0100, Andreas Mohr wrote:
> Hi,
> 
> On Mon, Nov 24, 2008 at 03:35:10PM +0100, Takashi Iwai wrote:
> > At Sat, 22 Nov 2008 21:00:18 +0200,
> > Maxim Levitsky wrote:
> > > Finally, I found how to reproduce that bug,
> > > I mean to get normal volume on internal mic, I have to increase volume
> > > only on left or right channel.
> > > 
> > > So, this happens always, and _only_ when recording _mono_ sound from internal
> > > mic.
> > > 
> > > Since hardware doesn't support hardware mono input, tested with -D hw:0
> > > I suspect this to be alsa-lib bug, any ideas?
> > > Happens with arecord -D plughw:0 -c1 .
> > 
> > What does show with -v option?
> 
> OK, I could fully reproduce this now (sorry for the delay!).
> 
> Currently 2.6.28, u8.10, model acer-aspire, libasound2 1.0.17a-0ubuntu4,
> libasound2-plugins 1.0.17-0ubuntu5.

Same microphone behaviour on 2.6.29-rc8 (additionally remembered to enable
CONFIG_SND_HDA_HWDEP for further testing!), u9.04, model acer-aspire,
libasound2 1.0.18-1ubuntu7, libasound2-plugins 1.0.18-1ubuntu4
(yes, I've just done some monster upgrade).

Will try to eventually analyze things using your _HWDEP-related tools.


2.6.29-rc8, in contrast to several other kernel upgrade occasions,
seems pretty solid so far, BTW.

Andreas Mohr
