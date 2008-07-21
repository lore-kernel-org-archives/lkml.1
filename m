Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbYGUUVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbYGUUVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 16:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbYGUUVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 16:21:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32860
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753157AbYGUUVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 16:21:00 -0400
Date: Mon, 21 Jul 2008 13:21:00 -0700 (PDT)
Message-Id: <20080721.132100.128525904.davem@davemloft.net>
To: Larry.Finger@lwfinger.net
Cc: mingo@elte.hu, ischram@telenet.be, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: [crash] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000370
From: David Miller <davem@davemloft.net>
In-Reply-To: <4884E6E6.7010800@lwfinger.net>
References: <4884DFEE.4060003@lwfinger.net>
	<20080721193425.GA29287@elte.hu>
	<4884E6E6.7010800@lwfinger.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Mon, 21 Jul 2008 14:43:34 -0500

> Jul 21 12:19:37 larrylap kernel: kernel BUG at net/core/dev.c:1328!
> Jul 21 12:19:37 larrylap kernel: invalid opcode: 0000 [1] SMP
> Jul 21 12:19:37 larrylap kernel: CPU 0
> Jul 21 12:19:37 larrylap kernel: Modules linked in: af_packet rfkill_input nfs 
> lockd nfs_acl sunrpc cpufreq_conservative cpu
> freq_userspace cpufreq_powersave powernow_k8 fuse loop dm_mod arc4 ecb 
> crypto_blkcipher b43 firmware_class rfkill mac80211 c
> fg80211 snd_hda_intel snd_pcm snd_timer led_class snd k8temp input_polldev 
> sr_mod soundcore button battery hwmon cdrom force
> deth ac serio_raw ssb snd_page_alloc sg ehci_hcd sd_mod ohci_hcd usbcore edd fan 
> thermal processor ext3 mbcache jbd pata_amd
>   ahci libata scsi_mod dock
> Jul 21 12:19:37 larrylap kernel: Pid: 2057, comm: b43 Not tainted 
> 2.6.26-Linus-git-05253-g14b395e #1
> Jul 21 12:19:37 larrylap kernel: RIP: 0010:[<ffffffff8039ec4d>] 
> [<ffffffff8039ec4d>] __netif_schedule+0x12/0x75
> Jul 21 12:19:37 larrylap kernel: RSP: 0000:ffff8800b9ae1de0  EFLAGS: 00010246
> 
> With an invalid opcode, mine is likely due to stack corruption.

No further backtrace?  That will tell us what driver is causing
this.

