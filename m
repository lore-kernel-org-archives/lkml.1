Return-Path: <linux-kernel-owner+w=401wt.eu-S1754922AbYKVToT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbYKVToT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 14:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYKVToE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 14:44:04 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:56043 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbYKVToD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 14:44:03 -0500
Date: Sat, 22 Nov 2008 20:43:59 +0100
From: Andreas Mohr <andi@lisas.de>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [alsa-devel] Bugs on aspire one A150
Message-ID: <20081122194359.GA29278@rhlx01.hs-esslingen.de>
References: <s5h3ai11dpt.wl%tiwai@suse.de> <20081109151323.GA18705@rhlx01.hs-esslingen.de> <s5h7i7c916e.wl%tiwai@suse.de> <20081109200929.GA29333@rhlx01.hs-esslingen.de> <s5hiqqtkxqr.wl%tiwai@suse.de> <491B0D38.1050207@gmail.com> <20081112180519.GA21919@rhlx01.hs-esslingen.de> <491DBDEA.9010104@gmail.com> <492856C2.8000707@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492856C2.8000707@gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Nov 22, 2008 at 09:00:18PM +0200, Maxim Levitsky wrote:
> Maxim Levitsky wrote:
>> 1) The dc offset isn't present on aspire one, really is a circuit 
>> design bug I guess 2) Internal mic works perfectly on aspire one, can 
>> reproduce the strange behaver at all,
>> Probably this was mixer bug.
> Finally, I found how to reproduce that bug,
> I mean to get normal volume on internal mic, I have to increase volume
> only on left or right channel.
>
> So, this happens always, and _only_ when recording _mono_ sound from internal
> mic.
>
> Since hardware doesn't support hardware mono input, tested with -D hw:0
> I suspect this to be alsa-lib bug, any ideas?
> Happens with arecord -D plughw:0 -c1 .

Wow, nice analysis!
I had already intended to report that you're #2 who told me that Mic does work
(and I was starting to feel weird since I'm the only one who cannot
get it to work!)
Given your analysis, things start to make a lot more sense now.

That probably means that Ekiga Wizard uses mono input (since it does not work
for me), whereas many other apps use stereo input as (natively!) supported
by this hardware setup?

--> alsa lib bug sounds like a good guess.

Thanks,

Andreas Mohr
