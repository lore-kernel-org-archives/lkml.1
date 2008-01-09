Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbYAIULh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbYAIULh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 15:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755528AbYAIULY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 15:11:24 -0500
Received: from mailout08.sul.t-online.de ([194.25.134.20]:43151 "EHLO
	mailout08.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754600AbYAIULW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 15:11:22 -0500
Message-ID: <47852A41.9020903@t-online.de>
Date: Wed, 09 Jan 2008 21:10:41 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc7, intel audio: alsa doesn't say a beep
References: <4782833D.3010600@t-online.de>	<s5h3at8rd9c.wl%tiwai@suse.de>	<4783AC7C.50900@t-online.de>	<s5h63y42oy6.wl%tiwai@suse.de>	<478463A6.2070106@t-online.de> <s5h8x2zo3ox.wl%tiwai@suse.de>
In-Reply-To: <s5h8x2zo3ox.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: r9pZJBZCohp93pbuirJ3uj9rdn4YKoJbSDgn69sZ0Tlbby8O6Uwb4YWMtXUMkhsgIm
X-TOI-MSGID: bdec3e48-44f9-43b2-8bca-1228499d62e0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> 
> Thanks.  Then the possible reason might be the registers that don't
> appear in this proc output, such as GPIO.
> Could you try the patch below with the latency patch (you reverted) in
> rc7?
> 

Using rc7:

hda_intel.c(rc6) + patch for sigmatel.c:     sound works
hda_intel.c(rc7) + patch for sigmatel.c:     sound does not work

Sorry to say, but AFAICS the patch for sigmatel.c doesn't fix
the problem.


Regards

Harri

