Return-Path: <linux-kernel-owner+w=401wt.eu-S1762941AbYAKVzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762941AbYAKVzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 16:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761250AbYAKVzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 16:55:35 -0500
Received: from mailout04.sul.t-online.de ([194.25.134.18]:43747 "EHLO
	mailout04.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760241AbYAKVzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 16:55:35 -0500
Message-ID: <4787E5D0.7000405@t-online.de>
Date: Fri, 11 Jan 2008 22:55:28 +0100
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
X-ID: X7qvP+ZJwhY59n9uE+4AzqZxpzibJ1s9+iU4LtpTFH9LZgEk+8xiuieWRGEz75NwN8
X-TOI-MSGID: 4a2f3677-e594-4b63-a6ad-6ebce4a99b2f
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

"Regression" sounds like a test suite to me, verifying that the
old problems didn't come back. Maybe you could send me a pointer?

Of course I didn't try that much yet. The kernel booted as expected,
I saw XWindow running, the mouse pointer was moving, etc. There was
just no sound, as before with rc7.

> Also, what exactly did you test?  "No sound" means that no sound from
> the headphone / line-out or from the speaker?
> 

Speaker and first headphone are the same on this laptop. If I plugin
the headphone, then the tiny speakers are disconnected. But for the
last tests no headphone was plugged in.

I tested it by running gnome-alsamixer. I tried to switch off and
on the mute buttons, change the volume and other sliders, etc.

> One interesting test would be to increase the value of udelay() in the
> reverted patch.  What happens if it's set to 500?
> 

I will try tomorrow. What exactly is this delay good for?

>>> The perex/alsa.git mm branch on kernel.org has many fixes.  Could you
>>> give it a try, too?
>>>
>> This version seems to work. But AFAICS it just reverts hda_intel.c back
>> to rc6 again, so this is no surprise.
> 
> Use mm branch.  The main branch is just an old Linus tree.
> 

AFAICS I did use the mm branch. The command to grab the sources was

git-clone git://git.kernel.org/pub/scm/linux/kernel/git/perex/alsa.git mm

Is this correct?


Regards

Harri

