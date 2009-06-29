Return-Path: <linux-kernel-owner+w=401wt.eu-S1759915AbZF2O3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915AbZF2O3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 10:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758484AbZF2O3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 10:29:24 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:51562 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758859AbZF2O3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 10:29:22 -0400
Message-ID: <4A48CFC1.2040103@msgid.tls.msk.ru>
Date: Mon, 29 Jun 2009 18:29:21 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       alsa-devel@vger.kernel.org
Subject: Re: PC speaker beeps in 2.6.30?
References: <4A365DA6.8000102@msgid.tls.msk.ru> <4A365DA6.8000102@msgid.tls.msk.ru> <4A4464CA.4060006@msgid.tls.msk.ru> <200906291447.08249.elendil@planet.nl>
In-Reply-To: <200906291447.08249.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> Michael Tokarev wrote:
>> Am I the only concerned about this?  My 2.6.30 is still
>> silent w.r.t. old good PC speaker beeps, and I wasn't
>> able to make it to produce any sound.  Yes, as pointed
>> out by others there is a control now, in alsa,
> 
> Did you actually try compiling a kernel without CONFIG_SND_HDA_INPUT_BEEP 
> set? If you do, does your PC speaker work again?

Yes it works.  Even with CONFIG_SND_HDA_INPUT_BEEP set,
but without the module loaded.  See all the details at
http://bugzilla.kernel.org/show_bug.cgi?id=13651

> If it does work again, I don't think there is a bug, at least not in the 
> fact that the old PC speaker beep no longer works: if you have a HDA 
> soundcard in the system _and_ the driver is loaded _and_ 
> CONFIG_SND_HDA_INPUT_BEEP is set, then it seems logical to me that that 
> takes over system beeps.
> The fact that the config option also existed in 2.6.29 but did not work 
> the same seems a minor issue to me.

Original issue was that I didn't know what to do.

[]
> If it really does sound bad, maybe the ALSA developers could look into 
> that, but you will have to describe it better (or maybe make a 
> recording?).

There was another, unrelated bug, fixed for 2.6.31-tobe.

/mjt
