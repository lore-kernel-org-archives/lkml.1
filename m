Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbZKIROP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbZKIROP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 12:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbZKIROP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 12:14:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:20168 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbZKIROO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 12:14:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,709,1249282800"; 
   d="scan'208";a="567903819"
Subject: Re: [ipw3945-devel] Warning in 2.6.32-rc6
From: reinette chatre <reinette.chatre@intel.com>
To: Norbert Preining <preining@logic.at>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20091108064000.GD13313@gamma.logic.tuwien.ac.at>
References: <20091108064000.GD13313@gamma.logic.tuwien.ac.at>
Content-Type: text/plain
Date: Mon, 09 Nov 2009 09:14:19 -0800
Message-Id: <1257786859.21134.22319.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-11-07 at 22:40 -0800, Norbert Preining wrote:
> [  307.587343] wlan0: deauthenticating from 00:0d:0b:04:5d:8d by local choice (reason=3)
> [  307.587434] wlan0: direct probe to AP 00:0d:0b:04:5d:8d (try 1)
> [  307.588623] wlan0: RX AssocResp from 00:0d:0b:04:5d:8d (capab=0x401 status=0 aid=3)
> [  307.588630] wlan0: associated
> [  307.589872] ------------[ cut here ]------------
> [  307.589909] WARNING: at net/wireless/mlme.c:97 cfg80211_send_rx_assoc+0x1a3/0x1a8 [cfg80211]()
> [  307.589915] Hardware name: VGN-Z11VN_B
> [  307.589919] Modules linked in: sco rfcomm bnep l2cap crc16 vboxnetadp vboxnetflt hso binfmt_misc dm_crypt dm_mod btrfs zlib_deflate crc32c libcrc32c vfat fat fuse vboxdrv loop uinput snd_hda_codec_realtek arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq iwlagn snd_timer snd_seq_device btusb iwlcore mac80211 bluetooth firewire_ohci snd cfg80211 joydev sony_laptop rfkill firewire_core crc_itu_t tpm_infineon soundcore snd_page_alloc
> [  307.590016] Pid: 1494, comm: phy0 Not tainted 2.6.32-rc6 #6
> [  307.590021] Call Trace:
> [  307.590040]  [<ffffffffa005d583>] ? cfg80211_send_rx_assoc+0x1a3/0x1a8 [cfg80211]
> [  307.590058]  [<ffffffffa005d583>] ? cfg80211_send_rx_assoc+0x1a3/0x1a8 [cfg80211]
> [  307.590070]  [<ffffffff8103ae54>] ? warn_slowpath_common+0x77/0xa3
> [  307.590088]  [<ffffffffa005d583>] ? cfg80211_send_rx_assoc+0x1a3/0x1a8 [cfg80211]
> [  307.590108]  [<ffffffffa00afd62>] ? ieee80211_sta_work+0x4bd/0xe6f [mac80211]
> [  307.590117]  [<ffffffff81033feb>] ? finish_task_switch+0x42/0xa5
> [  307.590127]  [<ffffffff8102d86b>] ? need_resched+0x1a/0x23
> [  307.590137]  [<ffffffff813405b3>] ? thread_return+0x97/0xd4
> [  307.590156]  [<ffffffffa00af8a5>] ? ieee80211_sta_work+0x0/0xe6f [mac80211]
> [  307.590166]  [<ffffffff8104967a>] ? worker_thread+0x151/0x1ee
> [  307.590176]  [<ffffffff8104cd60>] ? autoremove_wake_function+0x0/0x2e
> [  307.590184]  [<ffffffff81049529>] ? worker_thread+0x0/0x1ee
> [  307.590192]  [<ffffffff8104ca7d>] ? kthread+0x79/0x81
> [  307.590202]  [<ffffffff8100bf0a>] ? child_rip+0xa/0x20
> [  307.590210]  [<ffffffff8104ca04>] ? kthread+0x0/0x81
> [  307.590218]  [<ffffffff8100bf00>] ? child_rip+0x0/0x20
> [  307.590223] ---[ end trace f5bccb58d3019056 ]---
> [  307.605127] wlan0: deauthenticating from 00:0d:0b:04:5d:8d by local choice (reason=3)

This has been fixed. Please see
http://bugzilla.kernel.org/show_bug.cgi?id=14381

Reinette


