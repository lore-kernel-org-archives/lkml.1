Return-Path: <linux-kernel-owner+w=401wt.eu-S1760358AbYEQVCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760358AbYEQVCz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 17:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759994AbYEQVCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 17:02:44 -0400
Received: from mail.aknet.ru ([78.158.192.26]:55301 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975AbYEQVCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 17:02:43 -0400
Message-ID: <482F47DC.60505@aknet.ru>
Date: Sun, 18 May 2008 01:02:20 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dave Jones <davej@codemonkey.org.uk>
CC: Takashi Iwai <tiwai@suse.de>, Theodore Tso <tytso@mit.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roberto Oppedisano <roberto.oppedisano@infracom.it>
Subject: Re: [Bug #10679] 2.6.26-rc1 regression:	e5e1d3cb20034a3cbcfff1f0bae12201aa2ce17e
 breaks artsd
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A._sF.Ov1JIB@chimera> <s5hskwmeb1h.wl%tiwai@suse.de> <20080514212011.GH7054@mit.edu> <s5hhcd0azv1.wl%tiwai@suse.de> <20080515130654.GC18825@mit.edu> <s5h8wybr0c2.wl%tiwai@suse.de> <20080517204725.GA11460@codemonkey.org.uk>
In-Reply-To: <20080517204725.GA11460@codemonkey.org.uk>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Dave Jones wrote:
> More seriously, it doesn't seem that there's any way we can build
> this driver modular without it screwing up already working systems
> unless we cripple its MODULE_ALIAS to not autoload, allowing users
Maybe it is possible to adjust the
/etc/modprobe.d/modprobe.conf.dist
of module-init-tools and add there
something like the following?
options snd-pcsp index=10
It will then never became a default
driver.

