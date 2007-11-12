Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbXKLSqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbXKLSqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 13:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbXKLSqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 13:46:44 -0500
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:15265 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbXKLSqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 13:46:43 -0500
X-IronPort-AV: E=Sophos;i="4.21,406,1188802800"; 
   d="scan'208";a="31704121"
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: snd_hda_intel 2.6.24-rc2 bug: interrupts don't always work on Lenovo X60s
X-Message-Flag: Warning: May contain useful information
References: <ada1wb05p6n.fsf@cisco.com> <s5hbq9zyktm.wl%tiwai@suse.de>
	<adak5on2yd6.fsf@cisco.com> <s5hwssnvaw1.wl%tiwai@suse.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 12 Nov 2007 10:46:40 -0800
In-Reply-To: <s5hwssnvaw1.wl%tiwai@suse.de> (Takashi Iwai's message of "Mon, 12 Nov 2007 14:41:50 +0100")
Message-ID: <adafxzb2tf3.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Nov 2007 18:46:41.0048 (UTC) FILETIME=[5D2C9180:01C8255C]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > >     [ 2311.759856] ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 21
 > >     [ 2311.759866] hda_intel: probe_mask set to 0x1 for device 17aa:2010
 > >     [ 2311.759886] PCI: Setting latency timer of device 0000:00:1b.0 to 64
 > >     [ 2312.911309] hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x003f000c
 > 
 > Hm, strange, NID 0x03 shouldn't be accessed via AD1981 codec, at
 > least, thinkpad model.  Did you enable CONFIG_SND_HDA_CODEC_ANALOG?
 > Otherwise it won't work.

Yes, I have

    CONFIG_SND_HDA_CODEC_ANALOG=y

in my .config.

By the way, the "polling mode" seems to work OK: I still get normal
playback of music etc.

 - R.
