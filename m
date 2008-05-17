Return-Path: <linux-kernel-owner+w=401wt.eu-S1760947AbYEQWJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760947AbYEQWJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 18:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbYEQWJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 18:09:49 -0400
Received: from mail.aknet.ru ([78.158.192.26]:58388 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805AbYEQWJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 18:09:48 -0400
Message-ID: <482F579C.4090900@aknet.ru>
Date: Sun, 18 May 2008 02:09:32 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dave Jones <davej@codemonkey.org.uk>
CC: Takashi Iwai <tiwai@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
Subject: Re: [Bug #10679] 2.6.26-rc1 regression:	e5e1d3cb20034a3cbcfff1f0bae12201aa2ce17e
 breaks artsd
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A._sF.Ov1JIB@chimera> <s5hskwmeb1h.wl%tiwai@suse.de> <20080514212011.GH7054@mit.edu> <s5hhcd0azv1.wl%tiwai@suse.de> <20080515130654.GC18825@mit.edu> <s5h8wybr0c2.wl%tiwai@suse.de> <20080517204725.GA11460@codemonkey.org.uk> <482F47DC.60505@aknet.ru> <20080517213231.GA31440@codemonkey.org.uk> <482F56A5.7000008@aknet.ru>
In-Reply-To: <482F56A5.7000008@aknet.ru>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stas Sergeev wrote:
> for the "movable" index. For example,
> the index -2 can mean "use the first
> free slot, but move to the next one
> when some other driver is registering
> with -1 or explicitly to that slot".
> Of course I have no idea whether this
> is possible and acceptable, but maybe
... and for the obvious reasons this can't
work.
