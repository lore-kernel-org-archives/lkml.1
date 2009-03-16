Return-Path: <linux-kernel-owner+w=401wt.eu-S1760977AbZCPVWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760977AbZCPVWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715AbZCPVWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:22:31 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:39469 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712AbZCPVWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:22:30 -0400
Date: Mon, 16 Mar 2009 22:22:27 +0100
From: Andreas Mohr <andi@lisas.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andreas Mohr <andi@lisas.de>, Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [alsa-devel] Bugs on aspire one A150
Message-ID: <20090316212227.GA29471@rhlx01.hs-esslingen.de>
References: <s5h4oxtqy6q.wl%tiwai@suse.de> <20090316160208.GB4458@rhlx01.hs-esslingen.de> <s5hwsappi44.wl%tiwai@suse.de> <s5hprghphid.wl%tiwai@suse.de> <20090316170015.GA9776@rhlx01.hs-esslingen.de> <s5hljr5pex0.wl%tiwai@suse.de> <20090316173000.GA25647@rhlx01.hs-esslingen.de> <s5hiqm9pe1g.wl%tiwai@suse.de> <20090316180638.GB25647@rhlx01.hs-esslingen.de> <s5htz5tyzyg.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5htz5tyzyg.wl%tiwai@suse.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Mar 16, 2009 at 09:28:39PM +0100, Takashi Iwai wrote:
> At Mon, 16 Mar 2009 19:06:38 +0100,
> Andreas Mohr wrote:
> > I just tried connecting a headset and switching to E-Mic.
> > What I can say is:
> > - opposite levels does NOT happen there (E-Mic is "analog micro"-based, right?)
> > - leaving E-Mic unplugged will actually record from i-Mic (due to properly
> >   working EAPD mechanism, right?)
> 
> The record from mic-jack is via analog path.  The phase-inversion
> appears only for digital-mic, AFAIK.

Thought so.

> > One question still: is this a hardware defect (i.e. could this possibly
> > be swapped cables of the microphone connector in this model or so?
> > Not plausible but...), or is this an existing property
> > of the HDA's dig-mic base? You indicated it's the latter I think...
> 
> My guess is that it's a hardware implementation.
> Maybe for the noise suppression via mic array.

Not sure what this means.

> The question is whether the left / right channels recorded from
> digital mic are really raw data, or they are for modified data
> (for differential, etc)...  It's hard to guess without the actual
> data.

I don't quite follow you here. Is there anything I could do about this?

Thanks,

Andreas
