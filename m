Return-Path: <linux-kernel-owner+w=401wt.eu-S1758556AbYERNdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556AbYERNdA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 09:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbYERNcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 09:32:51 -0400
Received: from mail.aknet.ru ([78.158.192.26]:52383 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398AbYERNcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 09:32:50 -0400
Message-ID: <48306837.7030505@aknet.ru>
Date: Sun, 18 May 2008 21:32:39 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Roberto Oppedisano <roberto.oppedisano@infracom.it>,
       LKML <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org
Subject: Re: [patch] snd-pcsp: silent misleading warning
References: <482737BE.20502@infracom.it>	<4827415A.7060101@aknet.ru>	<482756F0.8020609@infracom.it>	<48275D8D.10500@aknet.ru>	<4827F0A1.9090600@infracom.it>	<48288ACC.1020909@aknet.ru>	<48299F08.2060702@infracom.it>	<4829B6A1.90707@infracom.it>	<s5h7idycfmf.wl%tiwai@suse.de>	<482A7A17.8070706@infracom.it>	<s5hwslxb3t8.wl%tiwai@suse.de>	<482C9A3E.3000009@infracom.it>	<482C9F3E.4050104@aknet.ru>	<482EC93E.7080702@infracom.it>	<482EFED2.1020504@aknet.ru> <s5hskwgkqe1.wl%tiwai@suse.de>
In-Reply-To: <s5hskwgkqe1.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Takashi Iwai wrote:
>>> [  417.338143] PCSP: playback_ptr inconsistent (4642 4661 18645)
>> It turns out that the buffer size you
>> get, is not evenly devided by period size.
>> 18645 % 4661 = 1.
>> That (wrongly) triggers the warning.
>> This may very well be an alsa bug, or
>> may not, but the code in the driver is
>> handling that properly, so there is no
>> need for such a verbose warning.
> The right fix would be to add a hw_constraint to align the buffer
> size.  The simplest way is to add the following in PCM open callback.
But what does this fix? That's only a
warning, the driver itself doesn't care
at all. The fix you propose, will need
more testing, at least a confirmation
from the reporter. I simply thought this
can't happen. Now you say its a perfectly
sane situation, and then there is nothing
to care about, just shut up the warning.
No?
