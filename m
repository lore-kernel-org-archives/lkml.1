Return-Path: <linux-kernel-owner+w=401wt.eu-S1759830AbZCPOut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759830AbZCPOut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 10:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbZCPOuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 10:50:39 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:52914 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbZCPOui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 10:50:38 -0400
Date: Mon, 16 Mar 2009 15:50:36 +0100
From: Andreas Mohr <andi@lisas.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andreas Mohr <andi@lisas.de>, Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [alsa-devel] Bugs on aspire one A150
Message-ID: <20090316145036.GA26358@rhlx01.hs-esslingen.de>
References: <491DBDEA.9010104@gmail.com> <492856C2.8000707@gmail.com> <s5hy6z9i44h.wl%tiwai@suse.de> <20090315092117.GA1567@rhlx01.hs-esslingen.de> <20090316120312.GA19299@rhlx01.hs-esslingen.de> <s5hocw1r7n5.wl%tiwai@suse.de> <20090316133001.GA8437@rhlx01.hs-esslingen.de> <s5hfxhdr1oz.wl%tiwai@suse.de> <20090316143158.GA12725@rhlx01.hs-esslingen.de> <s5hab7lr0k1.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hab7lr0k1.wl%tiwai@suse.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Mar 16, 2009 at 03:42:54PM +0100, Takashi Iwai wrote:
> At Mon, 16 Mar 2009 15:31:58 +0100,
> Andreas Mohr wrote:
> > 
> > Hi,
> > 
> > On Mon, Mar 16, 2009 at 03:18:20PM +0100, Takashi Iwai wrote:
> > > So, the following is also problematic
> > > 
> > > 	% arecord -fdat -c1 -Dplughw ng.wav
> > > 
> > > while the below works?
> > > 
> > > 	% arecord -fdat -Dhw good.wav
> > 
> > Indeed, the above has problems with problematic slider positions whereas
> > the below never has.
> 
> Err, could you be more specific about "slider positions"?

Hmm, I thought I was... (elsewhere)

In the problematic case (using plughw),
whenever left channel / right channel sliders are equal, no sound gets recorded.
IOW, there has to be a huge difference (in either direction)
between left and right channel slider to hear anything. And that is Not
A Good Feature to have ;)


> > > Does the conversion by sox from good.wav to a mono-channel file work?
> > 
> > I assume I should be using
> > sox good.wav -c1 good1.wav
> > ?
> > 
> > If so, yes, this works, audio is there.
> 
> Just to be sure - what about below?
> 	sox good.wav -c1 good1.wav mixer 0.5,0.5

Yep, still works.

Thanks,

Andreas
