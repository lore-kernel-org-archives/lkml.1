Return-Path: <linux-kernel-owner+w=401wt.eu-S932617AbYDYSMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617AbYDYSMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765468AbYDYSJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:09:46 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:56355 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765557AbYDYSJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:09:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Jn9KsZS10ZqIezbMvSFn1cIeKhKeZPFpb8W07SxkBZmPlkavZ3+TNTupbOZPQly+PFoAy3mfW82ehMWOjTTXUoX93QVhHTMnzFLYonwNf0isz4x8To+JGiCmXLfMs4mT7dn2Fek23k2riXgOR5yUg5YUa+ZGyPpL5vAOa5zMlfE=
Date: Fri, 25 Apr 2008 14:09:29 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-mm1 (snd-pcsp doesn't like DEBUG_PAGEALLOC)
Message-ID: <20080425140448.ZZRA012@mailhub.coreip.homeip.net>
References: <s5h8wz7cng7.wl%tiwai@suse.de> <480CD50F.20706@aknet.ru> <s5hbq42b3j7.wl%tiwai@suse.de> <480E2EE5.5040208@aknet.ru> <s5hiqy9dkhv.wl%tiwai@suse.de> <480F95BE.60109@aknet.ru> <s5h3apbd1zx.wl%tiwai@suse.de> <4811555E.3040509@aknet.ru> <s5hfxta4fem.wl%tiwai@suse.de> <48120ABF.1050802@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48120ABF.1050802@aknet.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stas,

On Fri, Apr 25, 2008 at 08:45:51PM +0400, Stas Sergeev wrote:
> Hello.
> 
> Takashi Iwai wrote:
> 
> > But anyway, as mentioned in my previous post, snd-pcsp wouldn't be
> > enabled on most of distros' kernels because it cannot be built
> > together with input-pcspkr driver, unfortunately...
> Yes, making them to play well together is
> something to think about too. But I don't
> see how it can affect the distributors.
> If the distro doesn't have the sound enabled,
> then it won't enable snd-pcsp no matter
> what. If it does have the sound enabled,
> then why would it ever want to use pcspkr
> instead of snd-pcsp?

Given agerage quality of the speakers in the current boxes and
abudance of on-board sound I doubt any distriution would want to have
snd-pcsp enabled since there is a chance it may come up as a primary
(default) sound device. At least my experience with F[C]7 that
juggling 3 sound cards is not very easy.

-- 
Dmitry
