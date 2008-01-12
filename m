Return-Path: <linux-kernel-owner+w=401wt.eu-S1763230AbYALJlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763230AbYALJlu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 04:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761487AbYALJlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 04:41:44 -0500
Received: from mailout05.sul.t-online.de ([194.25.134.82]:55470 "EHLO
	mailout05.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761471AbYALJln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 04:41:43 -0500
Message-ID: <47888B41.70803@t-online.de>
Date: Sat, 12 Jan 2008 10:41:21 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc7, intel audio: alsa doesn't say a beep
References: <4782833D.3010600@t-online.de>	<s5h3at8rd9c.wl%tiwai@suse.de>	<4783AC7C.50900@t-online.de>	<s5h63y42oy6.wl%tiwai@suse.de>	<478463A6.2070106@t-online.de>	<s5h8x2zo3ox.wl%tiwai@suse.de>	<47852A41.9020903@t-online.de>	<s5hr6gpajux.wl%tiwai@suse.de>	<4786960D.2040500@t-online.de> <s5hprw8g8m7.wl%tiwai@suse.de>
In-Reply-To: <s5hprw8g8m7.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: Go1Pt-ZQYhQyrBZ715CsJbUg2SkpYz5zi-H8npVxaytBRcOmJf9Xhuy9Kn7hU+ogWL
X-TOI-MSGID: 2d9735f8-b122-469a-ae2a-8eaa00dae6d7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> At Thu, 10 Jan 2008 23:02:53 +0100,
> Harald Dunkel wrote:
>> Takashi Iwai wrote:
>>> Hm...  Just to be sure, try the patch below.  It's a clean up patch
>>> that I'd like to apply later.
>>>
>> Sorry, no sound.
> 
> OK, but I'd like to know whether this makes no regression to rc6.
> Could you check?
> 
> Also, what exactly did you test?  "No sound" means that no sound from
> the headphone / line-out or from the speaker?
> 
> One interesting test would be to increase the value of udelay() in the
> reverted patch.  What happens if it's set to 500?
> 

There is no udelay() in the reverted patch. If I replace "udelay(10)"
by "udelay(500)" in the original rc7, then there is still no sound.

This is like fishing in the dark. We've got a working version. Why not
keep it?


Regards

Harri

