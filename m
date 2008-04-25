Return-Path: <linux-kernel-owner+w=401wt.eu-S1762043AbYDYSht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762043AbYDYSht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755268AbYDYShL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:37:11 -0400
Received: from el-out-1112.google.com ([209.85.162.178]:27768 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444AbYDYShI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:37:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=oBjUH4U8hgq82/F2LlYSQ0sf5m1U39eO5P4yYZy9bPsZIw5Ylw2VoUQ6zu1arU9GBXNB+dTR1v4Xw1G6YcYDjLKLDjjN2iAC6YjBjKvj1JJiVdXFEqGe6wIZ6IkzrPX0bfhh07jPeXSLQAD4fWuDWf3tkos7PrMOZoQJirJYHko=
Date: Fri, 25 Apr 2008 14:37:02 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-mm1 (snd-pcsp doesn't like DEBUG_PAGEALLOC)
Message-ID: <20080425143606.ZZRA012@mailhub.coreip.homeip.net>
References: <s5hbq42b3j7.wl%tiwai@suse.de> <480E2EE5.5040208@aknet.ru> <s5hiqy9dkhv.wl%tiwai@suse.de> <480F95BE.60109@aknet.ru> <s5h3apbd1zx.wl%tiwai@suse.de> <4811555E.3040509@aknet.ru> <s5hfxta4fem.wl%tiwai@suse.de> <48120ABF.1050802@aknet.ru> <20080425140448.ZZRA012@mailhub.coreip.homeip.net> <48122379.3080606@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48122379.3080606@aknet.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 10:31:21PM +0400, Stas Sergeev wrote:
> Hello.
> 
> Dmitry Torokhov wrote:
> > abudance of on-board sound I doubt any distriution would want to have
> > snd-pcsp enabled since there is a chance it may come up as a primary
> > (default) sound device.
> I avoid that by adding
> options snd-pcsp index=1
> into /etc/modprobe.conf.
> Maybe index=5 or alike would be
> safer for those who have many cards.

Yes, it could be. But face it, the number of users wanting to play
musuc through PC speaker is quite small and unlikely to increase in
the future.

-- 
Dmitry
