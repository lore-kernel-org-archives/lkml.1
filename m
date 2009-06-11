Return-Path: <linux-kernel-owner+w=401wt.eu-S932434AbZFKL3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434AbZFKL3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 07:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932134AbZFKL2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 07:28:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55060
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762832AbZFKL2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:28:45 -0400
Date: Thu, 11 Jun 2009 04:28:48 -0700 (PDT)
Message-Id: <20090611.042848.193715083.davem@davemloft.net>
To: tiwai@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: sound skipping regression introduced in 2.6.30-rc8
From: David Miller <davem@davemloft.net>
In-Reply-To: <s5hzlcflw2d.wl%tiwai@suse.de>
References: <20090610.112804.193703669.davem@davemloft.net>
	<s5hzlcflw2d.wl%tiwai@suse.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>
Date: Wed, 10 Jun 2009 21:37:14 +0200

> Could you set CONFIG_SND_PCM_XRUN_DEBUG=y and do
> 	# echo 1 > /proc/asound/card0/pcm0p/xrun_debug
> then check your app?  Does it work better, and get any kernel messages?

Yes, the skipping goes away and I get hw_ptr skipping kernel messages:

[61581.519051] PCM: hw_ptr skipping! (pos=10240, delta=15368, period=1024, jdelta=0/32)
[61584.420358] PCM: hw_ptr skipping! (pos=2048, delta=16328, period=1024, jdelta=2/34)
[61593.956318] PCM: hw_ptr skipping! (pos=1024, delta=15368, period=1024, jdelta=0/32)
[61596.964300] PCM: hw_ptr skipping! (pos=14336, delta=15368, period=1024, jdelta=0/32)
[61600.036292] PCM: hw_ptr skipping! (pos=14336, delta=15368, period=1024, jdelta=0/32)
[61605.454947] PCM: hw_ptr skipping! (pos=12288, delta=15368, period=1024, jdelta=0/32)

> Also, it'd be helpful if you can check whether the problem exists in
> the current sound git tree (for-linus branch), too.
>   git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git for-linus

I'm building this to test right now, will report when I try it out.
