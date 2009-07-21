Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbZGURZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbZGURZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 13:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755858AbZGURZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 13:25:36 -0400
Received: from [83.142.198.206] ([83.142.198.206]:37956 "EHLO
	orbiter.attika.ath.cx" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbZGURZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 13:25:36 -0400
Date: Tue, 21 Jul 2009 19:25:31 +0200
From: Piotr Kaczuba <pepe@attika.ath.cx>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ALSA] emu10k1: hw_ptr skipping when unpausing mplayer
Message-ID: <20090721172530.GA13121@attika.ath.cx>
References: <h3srvb$71b$1@ger.gmane.org>
 <s5hab2zc18e.wl%tiwai@suse.de>
 <20090720185721.GA7540@attika.ath.cx>
 <s5h4ot6powx.wl%tiwai@suse.de>
 <4A658D52.7050105@attika.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A658D52.7050105@attika.ath.cx>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 11:41:38AM +0200, Piotr Kaczuba wrote:
[...]
> No, it was with 2.6.30.1. I will try with the latest rc today evening.
[...]

With 2.6.31-rc3 there's definitely an improvement. Xrun_debug set to 5,
I see for example the following on unpause:

[  430.788525] __ratelimit: 97 callbacks suppressed
[  430.789516] PCM: hw_ptr skipping! [Q] (pos=3071, delta=16446,
period=1024, jdelta=1/342/0)
[  430.809853] PCM: hw_ptr skipping! [Q] (pos=4095, delta=2047,
period=1024, jdelta=21/42/0)
[  430.824984] PCM: hw_ptr skipping! (pos=4821, delta=2773, period=1024,
jdelta=36/57)
[  430.827087] PCM: hw_ptr skipping! (pos=4922, delta=2874, period=1024,
jdelta=39/59)
[  430.829350] PCM: hw_ptr skipping! (pos=5031, delta=2983, period=1024,
jdelta=41/62)
[  430.831256] PCM: hw_ptr skipping! [Q] (pos=5122, delta=3074,
period=1024, jdelta=43/64/1)
[  430.835786] PCM: hw_ptr skipping! (pos=5340, delta=2268, period=1024,
jdelta=4/47)
[  430.837913] PCM: hw_ptr skipping! (pos=5442, delta=2370, period=1024,
jdelta=6/49)
[  430.839881] PCM: hw_ptr skipping! (pos=5536, delta=2464, period=1024,
jdelta=8/51)
[  430.842959] PCM: hw_ptr skipping! (pos=5684, delta=2612, period=1024,
jdelta=11/54)


But there's no flood of messages anymore and no tracebacks either. In
fact, mplayer continues to play without any stutter.

Thanks,
Piotr
