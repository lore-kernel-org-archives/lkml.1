Return-Path: <linux-kernel-owner+w=401wt.eu-S1757014AbYDYDwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbYDYDwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 23:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbYDYDwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 23:52:12 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:64244 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753199AbYDYDwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 23:52:12 -0400
Message-ID: <4811555E.3040509@aknet.ru>
Date: Fri, 25 Apr 2008 07:51:58 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-mm1 (snd-pcsp doesn't like DEBUG_PAGEALLOC)
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>	<20080419021343.GA3503@nineveh.local>	<20080418200237.b5a9e805.akpm@linux-foundation.org>	<20080419041429.GA8508@anvil.corenet.prv>	<20080418212934.bbe84ee2.akpm@linux-foundation.org>	<s5h8wz7cng7.wl%tiwai@suse.de>	<480CD50F.20706@aknet.ru>	<s5hbq42b3j7.wl%tiwai@suse.de>	<480E2EE5.5040208@aknet.ru>	<s5hiqy9dkhv.wl%tiwai@suse.de>	<480F95BE.60109@aknet.ru> <s5h3apbd1zx.wl%tiwai@suse.de>
In-Reply-To: <s5h3apbd1zx.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Takashi Iwai wrote:
> No, I don't think input-pcspkr would be ever easily obsoleted by
> snd-pcsp.  People definitely want a system without the sound subsystem
> but with a beep.
If you don't enable sound, then you
can't enable snd-pcsp, and so the
pcspkr can be enabled.
But if you have enabled the sound,
what's the use in not seeing the
snd-pcsp in the config?
Because most people already had
pcspkr enabled I guess, this just
reduces the availability of snd-pcsp
by an order of magnitude. And the
reason for that, is... ?
