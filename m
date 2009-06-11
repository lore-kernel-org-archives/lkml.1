Return-Path: <linux-kernel-owner+w=401wt.eu-S1757719AbZFKVia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719AbZFKVia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 17:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbZFKViV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 17:38:21 -0400
Received: from mail.uni-paderborn.de ([131.234.142.9]:22868 "EHLO
	mail.uni-paderborn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbZFKViU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 17:38:20 -0400
Message-ID: <4A317949.9090301@gmail.com>
Date: Thu, 11 Jun 2009 23:38:17 +0200
From: =?ISO-8859-1?Q?Sven_K=F6hler?= <sven.koehler@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090509)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Takashi Iwai <tiwai@suse.de>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: sound skipping regression introduced in 2.6.30-rc8
References: <20090610.112804.193703669.davem@davemloft.net>	<4A300B85.2010106@gmail.com>	<s5hr5xrvb5m.wl%tiwai@suse.de>	<4A30A882.5080206@gmail.com> <s5h7hzjtc87.wl%tiwai@suse.de>
In-Reply-To: <s5h7hzjtc87.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-IMT-Spam-Score: 0.0 ()
X-PMX-Version: 5.5.5.374460, Antispam-Engine: 2.7.1.369594, Antispam-Data: 2009.6.11.212830
X-IMT-Authenticated-Sender: uid=skoehler,ou=People,o=upb,c=de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> Can somebody point out, how I can set this xrun_debug thing or can
>>>> somebody provide a patch that reverts the change?
>>> Did you read my reply to David?
>> I will try, what is described there and I will report back if I get any
>> debug output.
> 
> Thanks, that'll be be helpful.

Below is the output. Note, that audacious 2.x was not only skipping a
little bit. In fact, the clock that was showing the time of audio played
was running twice as fast or even 4 times as fast. The sound was played
at the right samplerate but in fast it seems, that much of the audio
data was skipped and I only heard a series of short fragments of what
should have been the song I'm listening to.


PCM: hw_ptr skipping! (pos=4096, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=4096, delta=7611, period=1024, jdelta=10/158)
PCM: hw_ptr skipping! (pos=4096, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=6144, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=3072, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=5120, delta=7630, period=1024, jdelta=10/158)
PCM: hw_ptr skipping! (pos=3072, delta=7629, period=1024, jdelta=10/158)
PCM: hw_ptr skipping! (pos=6144, delta=7609, period=1024, jdelta=9/158)
PCM: hw_ptr skipping! (pos=5120, delta=7618, period=1024, jdelta=10/158)
PCM: hw_ptr skipping! (pos=1024, delta=7620, period=1024, jdelta=9/158)
PCM: hw_ptr skipping! (pos=4096, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=3072, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=0, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=7168, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=1024, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=6144, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=6144, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=3072, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=4096, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=5120, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=6144, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=7168, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=0, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=1024, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=2048, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=3072, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=4096, delta=7169, period=1024, jdelta=0/149)
__ratelimit: 202 callbacks suppressed
PCM: hw_ptr skipping! (pos=7168, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=0, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=1024, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=2048, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=3072, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=4096, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=5120, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=6144, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=7168, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=0, delta=7169, period=1024, jdelta=0/149)
__ratelimit: 202 callbacks suppressed
PCM: hw_ptr skipping! (pos=3072, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=4096, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=5120, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=6144, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=7168, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=1024, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=2048, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=3072, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=4096, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=5120, delta=7169, period=1024, jdelta=0/149)
__ratelimit: 196 callbacks suppressed
PCM: hw_ptr skipping! (pos=7168, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=0, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=1024, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=2048, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=3072, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=4096, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=5120, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=6144, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=7168, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=0, delta=7169, period=1024, jdelta=0/149)
__ratelimit: 201 callbacks suppressed
PCM: hw_ptr skipping! (pos=3072, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=4096, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=5120, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=6144, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=7168, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=0, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=1024, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=2048, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=3072, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=4096, delta=7169, period=1024, jdelta=0/149)
__ratelimit: 199 callbacks suppressed
PCM: hw_ptr skipping! (pos=7168, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=0, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=1024, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=2048, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=3072, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=4096, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=5120, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=6144, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=7168, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=0, delta=7169, period=1024, jdelta=0/149)
__ratelimit: 199 callbacks suppressed
PCM: hw_ptr skipping! (pos=3072, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=4096, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=5120, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=6144, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=7168, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=0, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=1024, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=2048, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=3072, delta=7169, period=1024, jdelta=0/149)
PCM: hw_ptr skipping! (pos=4096, delta=7169, period=1024, jdelta=0/149)
__ratelimit: 12 callbacks suppressed
PCM: hw_ptr skipping! (pos=4096, delta=7610, period=1024, jdelta=9/158)
PCM: hw_ptr skipping! (pos=4096, delta=7611, period=1024, jdelta=9/158)



Regards,
  Sven
