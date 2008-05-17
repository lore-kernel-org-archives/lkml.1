Return-Path: <linux-kernel-owner+w=401wt.eu-S1760215AbYEQVcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215AbYEQVcW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 17:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759611AbYEQVcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 17:32:11 -0400
Received: from testure.choralone.org ([194.9.77.134]:46970 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbYEQVcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 17:32:09 -0400
Date: Sat, 17 May 2008 17:32:31 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Takashi Iwai <tiwai@suse.de>, Theodore Tso <tytso@mit.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roberto Oppedisano <roberto.oppedisano@infracom.it>
Subject: Re: [Bug #10679] 2.6.26-rc1 regression:
	e5e1d3cb20034a3cbcfff1f0bae12201aa2ce17e breaks artsd
Message-ID: <20080517213231.GA31440@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Stas Sergeev <stsp@aknet.ru>, Takashi Iwai <tiwai@suse.de>,
	Theodore Tso <tytso@mit.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Roberto Oppedisano <roberto.oppedisano@infracom.it>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A._sF.Ov1JIB@chimera> <s5hskwmeb1h.wl%tiwai@suse.de> <20080514212011.GH7054@mit.edu> <s5hhcd0azv1.wl%tiwai@suse.de> <20080515130654.GC18825@mit.edu> <s5h8wybr0c2.wl%tiwai@suse.de> <20080517204725.GA11460@codemonkey.org.uk> <482F47DC.60505@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482F47DC.60505@aknet.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2008 at 01:02:20AM +0400, Stas Sergeev wrote:
 > Hello.
 > 
 > Dave Jones wrote:
 > > More seriously, it doesn't seem that there's any way we can build
 > > this driver modular without it screwing up already working systems
 > > unless we cripple its MODULE_ALIAS to not autoload, allowing users
 > Maybe it is possible to adjust the
 > /etc/modprobe.d/modprobe.conf.dist
 > of module-init-tools and add there
 > something like the following?
 > options snd-pcsp index=10
 > It will then never became a default
 > driver.

Unless someone has 10 sound cards :-)  (Sounds bizarre, but I never tire
of seeing some of the creative situations our users get themselves into).

Something like this is probably the only real supportable way to do it though.
It would be great if alsa took something like -1 to mean 'never make this default'.

But until that lands in a module-init-tools update, we're kind of stuck.

	Dave

-- 
http://www.codemonkey.org.uk
