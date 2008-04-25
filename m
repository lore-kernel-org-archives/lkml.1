Return-Path: <linux-kernel-owner+w=401wt.eu-S1759253AbYDYSbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbYDYSbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYDYSbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:31:32 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:64898 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbYDYSbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:31:31 -0400
Message-ID: <48122379.3080606@aknet.ru>
Date: Fri, 25 Apr 2008 22:31:21 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-mm1 (snd-pcsp doesn't like DEBUG_PAGEALLOC)
References: <s5h8wz7cng7.wl%tiwai@suse.de> <480CD50F.20706@aknet.ru> <s5hbq42b3j7.wl%tiwai@suse.de> <480E2EE5.5040208@aknet.ru> <s5hiqy9dkhv.wl%tiwai@suse.de> <480F95BE.60109@aknet.ru> <s5h3apbd1zx.wl%tiwai@suse.de> <4811555E.3040509@aknet.ru> <s5hfxta4fem.wl%tiwai@suse.de> <48120ABF.1050802@aknet.ru> <20080425140448.ZZRA012@mailhub.coreip.homeip.net>
In-Reply-To: <20080425140448.ZZRA012@mailhub.coreip.homeip.net>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Dmitry Torokhov wrote:
> abudance of on-board sound I doubt any distriution would want to have
> snd-pcsp enabled since there is a chance it may come up as a primary
> (default) sound device.
I avoid that by adding
options snd-pcsp index=1
into /etc/modprobe.conf.
Maybe index=5 or alike would be
safer for those who have many cards.
