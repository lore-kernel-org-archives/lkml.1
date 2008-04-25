Return-Path: <linux-kernel-owner+w=401wt.eu-S1764429AbYDYRZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764429AbYDYRZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 13:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbYDYRZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:25:18 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:53157 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770AbYDYRZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:25:16 -0400
Message-ID: <481213F3.3050006@aknet.ru>
Date: Fri, 25 Apr 2008 21:25:07 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-mm1 (snd-pcsp doesn't like DEBUG_PAGEALLOC)
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>	<20080419021343.GA3503@nineveh.local>	<20080418200237.b5a9e805.akpm@linux-foundation.org>	<20080419041429.GA8508@anvil.corenet.prv>	<20080418212934.bbe84ee2.akpm@linux-foundation.org>	<s5h8wz7cng7.wl%tiwai@suse.de>	<480CD50F.20706@aknet.ru>	<s5hbq42b3j7.wl%tiwai@suse.de>	<480E2EE5.5040208@aknet.ru>	<s5hiqy9dkhv.wl%tiwai@suse.de>	<480F95BE.60109@aknet.ru>	<s5h3apbd1zx.wl%tiwai@suse.de>	<4811555E.3040509@aknet.ru>	<s5hfxta4fem.wl%tiwai@suse.de>	<48120ABF.1050802@aknet.ru> <s5hve25j2tj.wl%tiwai@suse.de>
In-Reply-To: <s5hve25j2tj.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Takashi Iwai wrote:
> The sound subsystem is enabled (loaded) only when necessary.
> As long as there are many systems without the sound subsystem
> (i.e. servers),
Is it really a problem for the server
admin to just tolerate a few extra modules
being loaded? I really don't know, I just
thought it is not.
Of course the one may not like the fact
that after the kernel update, he gets a
few modules more in lsmod output; someone
may even call it a bloat...
$ lsmod |wc -l
79
Doesn't look too small already. :)

Anyway, I guess we'll soon find out the
numbers, unless someone will come up with
the good way to make those drivers to
play better together and to not depend
on each other, which looks a bit difficult
from the first glance.
