Return-Path: <linux-kernel-owner+w=401wt.eu-S1753717AbZEQUiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbZEQUiU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 16:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbZEQUiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 16:38:06 -0400
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:56536 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752628AbZEQUiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 16:38:05 -0400
Subject: Re: regression in 2.6.30-rc6 -- via82xx sound very quiet
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Takashi Iwai <tiwai@suse.de>
Cc: perex@perex.cz, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <s5h7i0f7iqo.wl%tiwai@suse.de>
References: <1242578874.2748.11.camel@localhost.localdomain>
	 <s5h7i0f7iqo.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Sun, 17 May 2009 21:38:03 +0100
Message-Id: <1242592683.2748.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-17 at 19:16 +0200, Takashi Iwai wrote:
> At Sun, 17 May 2009 17:47:54 +0100,
> Richard Kennedy wrote:
> > 
> > In the current git 2.6.30-rc6 the sound from my motherboard has become
> > extremely quiet, I have to turn my speakers up all the way to hear
> > anything at all.
> > I'm not too sure when the problem first started but I've just tested
> > 2.6.30-rc4 and it works correctly.  
> 
> Try to correct "DXS Playback Volume" mixer elements.
> The dB range of these volumes were fixed recently to the correct
> values.  If the old mixer value is restored using the dB value,
> it would be restored to a much lower value, which explains your
> symptom.
> 
> Simply set these volumes to the max (i.e. 0dB) and never change unless
> you really need them.
> 
> 
> thanks,
> 
> Takashi

Hi Takashi,

thanks for that. Yes that works.

I didn't even know I had that control, so I guess this could be a common
problem.

regards
Richard

