Return-Path: <linux-kernel-owner+w=401wt.eu-S1752158AbYJRQRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbYJRQRt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 12:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbYJRQRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 12:17:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49749 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbYJRQRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 12:17:39 -0400
Message-ID: <48FA0C27.8010301@scherping.de>
Date: Sat, 18 Oct 2008 18:17:43 +0200
From: Richard Scherping <richard@scherping.de>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: Frederik Himpe <fhimpe@telenet.be>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: iwlagn: associating with AP causes kernel hiccup
References: <gd5gs4$abi$1@ger.gmane.org> <1224104363.19219.30.camel@rc-desk>	 <gd9v3f$3ft$1@ger.gmane.org> <gd9vpo$5ql$1@ger.gmane.org>	 <48F8AEF1.5030603@scherping.de> <1ba2fa240810171302h7dcc92acr18c060425c4a93d@mail.gmail.com>
In-Reply-To: <1ba2fa240810171302h7dcc92acr18c060425c4a93d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19of+w0x7+4aQ1ujr5NGE6R1cxYl12QpBXFu46
 1of+tZ/TwNs+OKq380/9fKwQqECVQVxffDc4N1/OWbkIqINfY4
 TpshsKfpaamKq7hngC01TQjomy8byVt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomas Winkler schrieb:
> On Fri, Oct 17, 2008 at 5:27 PM, Richard Scherping <richard@scherping.de> wrote:
>>>>>> When I associate with an AP, Linux 2.6.27 seems to "hang" for a few
>>>>>> seconds. During that time, all sound stops playing and keyboard and
>>>>>> mouse input is impossible.
>>>> I'm using Mandriva 2009.0 x86_64 with wpa_supplicant and Mandriva's
>>>> wireless network configuration tool (drakroam).
>>>>
>>>> Actually I just found out that running # ifconfig wlan0 down
>>>> is enough to trigger the sound and mouse hanging for a few seconds.
>>> And shortly after I wrote that, while associating while getting an IP
>>> with dhclient when associating with a WPA encrypted AP, I got this
>>> backtrace in my logs:
>>> [...]
>> I have a similar problem here. No crash up to now, but the very same "hang" for a few seconds on "ifconfig wlan0 down". Interestingly this does only happen after a normal boot - once I did a suspend and resume (S3), there is no hang anymore.
>>
>> Hardware: Thinkpad T61p with Intel 4965 agn
>> Software: Debian Lenny x86_64 with vanilla 2.6.27 kernel
>>
> Driver in 2.6.27 is not stable, please try to reproduce this in
> current wireless-testing.git.

I do not have the time to compile and test wireless-testing ATM, sorry.

In fact I am annoyed by the fact that iwlagn is "known to be unstable" in a stable kernel release and that this even seems to be a totally normal thing...

Once compat-wireless is working again on my system I will try that and check whether the hang still occurs. Current compat-wireless does not for me - compilation says

make[1]: Entering directory `/usr/src/linux-2.6.27'
/home/richard/Desktop/compat-wireless-2008-10-17/config.mk:44: "WARNING: You are running a kernel >= 2.6.23, you should enable in it CONFIG_NETDEVICES_MULTIQUEUE for 802.11[ne] support"

and I did not find CONFIG_NETDEVICES_MULTIQUEUE using menuconfig. Loading the modules fails with tons of unknown symbols and disagreed versions (already at cfg80211 and mac80211 modules).

Perhaps I should go back to Debian stock 2.6.26 kernel - but there Ad-Hoc is broken on iwl4965, although it was working without problems earlier in 2.6.24.

Richard
