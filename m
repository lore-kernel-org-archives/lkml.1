Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbYDLXzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbYDLXzo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 19:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754588AbYDLXzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 19:55:33 -0400
Received: from fmmailgate09.web.de ([217.72.192.184]:57451 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbYDLXzc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 19:55:32 -0400
Date: Sun, 13 Apr 2008 01:51:23 +0200
Message-Id: <236729512@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Subject: =?iso-8859-15?Q?Device_'virtio-pci'_does_not_have_a_release()_function?=
 =?iso-8859-15?Q?,_it_is_broken_and_must_be_fixed.?=
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/kuI3g5G6KPEKPL4oEYCkc7T5OUeQMJ9U1/AwwnKXUhmJUh
 I833CrWGQn0cROD52r7nsr61Eu6jipi++cZBTPT2gbEjnyKTh4=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with 2.6.25-rc8 - modprobe -r virtio-pci gives:


Apr 13 01:30:57 neo klogd: Device 'virtio-pci' does not have a release() function, it is broken and must be fixed.
Apr 13 01:30:57 neo klogd: ------------[ cut here ]------------
Apr 13 01:30:57 neo klogd: WARNING: at drivers/base/core.c:119 device_release+0x58/0x5c()
Apr 13 01:30:57 neo klogd: Modules linked in: virtio_pci(-) eni suni zatm uPD98402 atm sha1_generic michael_mic tgr192 seed arc4 xts lrw gf128mul aes_i586 aes_generic twofish_i586 twofish_common cbc ecb nls_koi8_u nls_cp932 sunrpc sctp libcrc32c decnet 9pnet_fd 9pnet crypto_blkcipher dccp_ipv6 dccp_ipv4 dccp ipv6 savage drm snd_pcm_oss snd_mixer_oss snd_seq fuse loop dm_mod snd_via82xx gameport snd_ac97_codec ac97_bus snd_pcm snd_timer snd_page_alloc snd_mpu401_uart 8139cp snd_rawmidi snd_seq_device 8139too snd button via_agp mii soundcore agpgart via686a sg sd_mod edd ext3 mbcache jbd fan pata_via libata dock mptspi mptscsih mptbase scsi_transport_spi scsi_mod thermal processor [last unloaded: virtio_balloon]
Apr 13 01:30:57 neo klogd: Pid: 23045, comm: modprobe Tainted: G        N 2.6.25-rc8-12-default #1
Apr 13 01:30:57 neo klogd:  [<c01072d9>] dump_trace+0x63/0x227
Apr 13 01:30:57 neo klogd:  [<c0107d8a>] show_trace+0x15/0x29
Apr 13 01:30:57 neo klogd:  [<c02e56c4>] _etext+0x5b/0x65
Apr 13 01:30:57 neo klogd:  [<c0124f65>] warn_on_slowpath+0x41/0x67
Apr 13 01:30:57 neo klogd:  [<c02495da>] device_release+0x58/0x5c
Apr 13 01:30:57 neo klogd:  [<c01dd1bc>] kobject_release+0x40/0x50
Apr 13 01:30:57 neo klogd:  [<c01ddc8d>] kref_put+0x39/0x44
Apr 13 01:30:57 neo klogd:  [<c01dd0ff>] kobject_put+0x14/0x16
Apr 13 01:30:57 neo klogd:  [<c0249099>] put_device+0xf/0x11
Apr 13 01:30:57 neo klogd:  [<c0249b0c>] device_unregister+0x12/0x15
Apr 13 01:30:57 neo klogd:  [<d004e3b1>] virtio_pci_exit+0xd/0x19 [virtio_pci]
Apr 13 01:30:57 neo klogd:  [<c014441e>] sys_delete_module+0x1a8/0x1e6
Apr 13 01:30:57 neo klogd:  [<c0105b62>] syscall_call+0x7/0xb
Apr 13 01:30:57 neo klogd:  [<ffffe422>] 0xffffe422
Apr 13 01:30:57 neo klogd:  =======================
Apr 13 01:30:57 neo klogd: ---[ end trace 83e80abb363f13f7 ]--


_______________________________________________________________
Schon gehört? Der neue WEB.DE MultiMessenger kann`s mit allen: 
http://www.produkte.web.de/messenger/?did=3016

