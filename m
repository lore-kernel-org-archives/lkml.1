Return-Path: <linux-kernel-owner+w=401wt.eu-S1751548AbZHSMtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbZHSMtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 08:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZHSMtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 08:49:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:47970 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751279AbZHSMtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 08:49:13 -0400
X-Authenticated: #32306085
X-Provags-ID: V01U2FsdGVkX1/lxGExklzlKIIz6XdWrm/EwpQ4ILTyhXayS27NRX
	2PO4o1GqKs1XIr
From: Christoph Thielecke <christoph.thielecke@gmx.de>
Reply-To: christoph.thielecke@gmx.de
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>
Subject: kernel bug 2.6.31-rc6 (2)
Date: Wed, 19 Aug 2009 14:48:45 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2788521.HLxJi9iYJz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200908191448.50304.christoph.thielecke@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2788521.HLxJi9iYJz
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello list,

another freeze comes here (still using xephr):

Aug 19 14:04:22 develop kernel: plasma[30850]: segfault at 4 ip b6acef4d sp=
=20
bfe72230 error 4 in libQtGui.so.4.5.1[b6993000+81a000]
Aug 19 14:05:03 develop kernel: idr_remove called for id=3D1024 which is no=
t=20
allocated.
Aug 19 14:05:03 develop kernel: Pid: 11958, comm: kded4 Tainted: P        W=
 =20
2.6.31-rc6 #2
Aug 19 14:05:03 develop kernel: Call Trace:
Aug 19 14:05:03 develop kernel: [<c133a0b0>] ? printk+0x18/0x20
Aug 19 14:05:03 develop kernel: [<c11d00c0>] idr_remove+0x79/0x1ad
Aug 19 14:05:03 develop kernel: [<c10db9d1>] ?=20
fsnotify_add_notify_event+0x105/0x205
Aug 19 14:05:03 develop kernel: [<c10ddce3>] inotify_remove_from_idr+0x21/0=
x34
Aug 19 14:05:03 develop kernel: [<c10de1ae>]=20
inotify_ignored_and_remove_idr+0x85/0xb7
Aug 19 14:05:03 develop kernel: [<c10dd753>] inotify_freeing_mark+0x8/0xa
Aug 19 14:05:03 develop kernel: [<c10dc3ab>]=20
fsnotify_destroy_mark_by_entry+0xf3/0x132
Aug 19 14:05:03 develop kernel: [<c10dc532>]=20
fsnotify_clear_marks_by_group+0x9b/0xc9
Aug 19 14:05:03 develop kernel: [<c10dd8e5>] inotify_release+0x12/0x26
Aug 19 14:05:03 develop kernel: [<c10b3dfa>] __fput+0xd3/0x1ba
Aug 19 14:05:03 develop kernel: [<c10b3efc>] fput+0x1b/0x20
Aug 19 14:05:03 develop kernel: [<c10b108e>] filp_close+0x41/0x5f
Aug 19 14:05:03 develop kernel: [<c10342d5>] put_files_struct+0x68/0xa6
Aug 19 14:05:03 develop kernel: [<c103434a>] exit_files+0x37/0x3c
Aug 19 14:05:03 develop kernel: [<c1035777>] do_exit+0x146/0x6c6
Aug 19 14:05:03 develop kernel: [<c1035d27>] do_group_exit+0x30/0x85
Aug 19 14:05:03 develop kernel: [<c1035d8f>] sys_exit_group+0x13/0x17
Aug 19 14:05:03 develop kernel: [<c1003610>] sysenter_do_call+0x12/0x2c
Aug 19 14:05:03 develop kernel: ------------[ cut here ]------------
Aug 19 14:05:03 develop kernel: kernel BUG at=20
fs/notify/inotify/inotify_fsnotify.c:109!
Aug 19 14:05:03 develop kernel: invalid opcode: 0000 [#1] PREEMPT SMP
Aug 19 14:05:03 develop kernel: last sysfs=20
file: /sys/devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7.2/product
Aug 19 14:05:03 develop kernel: Modules linked in: xt_TCPMSS xt_tcpudp=20
iptable_filter ip_tables x_tables ppp_async crc_ccitt ppp_mppe nvidia(P)=20
binfmt_misc ppdev parport_pc lp parport rfcomm l2cap tun vboxnetadp=20
vboxnetflt vboxdrv pppol2tp pppox ppp_generic slhc ipv6 capifs acpi_cpufreq=
=20
cpufreq_ondemand cpufreq_powersave cpufreq_stats freq_table cpufreq_userspa=
ce=20
cpufreq_conservative nfsd nfs lockd fscache nfs_acl auth_rpcgss sunrpc=20
deflate zlib_deflate ctr twofish twofish_common camellia serpent blowfish=20
cast5 des_generic cbc aes_i586 aes_generic xcbc rmd160 sha256_generic=20
sha1_generic crypto_null af_key nls_iso8859_1 nls_cp437 vfat fat fuse=20
dm_snapshot dm_mirror dm_region_hash dm_log dm_mod coretemp loop asix dm960=
1=20
pl2303 usbnet usbserial usbhid hid btusb bluetooth snd_hda_codec_idt=20
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss arc4=20
usb_storage snd_pcm ecb snd_seq_dummy snd_seq_oss firewire_ohci snd_seq_mid=
i=20
snd_rawmidi iwl3945 firewire_core joydev snd_seq_midi_event iwlcore crc_itu=
_t=20
b44 iTCO_wdt snd_seq ssb iTCO_vendor_support snd_timer snd_seq_device=20
sdhci_pci sdhci mac80211 ohci1394 pcmcia pcmcia_core rtc_cmos rtc_core snd=
=20
mmc_core i2c_i801 intel_agp uhci_hcd ehci_hcd ricoh_mmc ieee1394 mii psmous=
e=20
video rtc_lib soundcore snd_page_alloc led_class i2c_core agpgart cfg80211=
=20
usbcore battery ac button processor serio_raw output wmi dell_laptop therma=
l=20
rfkill sg sr_mod cdrom evdev
Aug 19 14:05:03 develop kernel:
Aug 19 14:05:03 develop kernel: Pid: 11958, comm: kded4 Tainted: P        W=
 =20
(2.6.31-rc6 #2) MP061
Aug 19 14:05:03 develop kernel: EIP: 0060:[<c10dd747>] EFLAGS: 00210282 CPU=
: 0
Aug 19 14:05:03 develop kernel: EIP is at idr_callback+0x3/0x7
Aug 19 14:05:03 develop kernel: EAX: 00000000 EBX: 00000000 ECX: 00000000 E=
DX:=20
eea26cd0
Aug 19 14:05:03 develop kernel: ESI: f13c9e80 EDI: 00000000 EBP: f13c9e5c E=
SP:=20
f13c9e5c
Aug 19 14:05:03 develop kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Aug 19 14:05:03 develop kernel: Process kded4 (pid: 11958, ti=3Df13c8000=20
task=3Dee942450 task.ti=3Df13c8000)
Aug 19 14:05:03 develop kernel: Stack:
Aug 19 14:05:03 develop kernel: f13c9ea0 c11cf6fe 00000000 c10dd744 0000040=
0=20
eea26cd0 00000000 efe90c14
Aug 19 14:05:03 develop kernel: <0> eede5a58 f13c9e8c c10dbb0a f2470858=20
f13c9eac c10dbba6 ef806fa0 f6927a40
Aug 19 14:05:03 develop kernel: <0> f6c4a9e8 f13c9eac c10dd76c ef806f40=20
f13c9eb8 c10dbc0f ef806f40 f13c9ec4
Aug 19 14:05:03 develop kernel: Call Trace:
Aug 19 14:05:03 develop kernel: [<c11cf6fe>] ? idr_for_each+0x62/0xb0
Aug 19 14:05:03 develop kernel: [<c10dd744>] ? idr_callback+0x0/0x7
Aug 19 14:05:03 develop kernel: [<c10dbb0a>] ? fsnotify_put_event+0x39/0x4a
Aug 19 14:05:03 develop kernel: [<c10dbba6>] ? fsnotify_flush_notify+0x8b/0=
x95
Aug 19 14:05:03 develop kernel: [<c10dd76c>] ?=20
inotify_free_group_priv+0x17/0x28
Aug 19 14:05:03 develop kernel: [<c10dbc0f>] ?=20
fsnotify_final_destroy_group+0x19/0x23
Aug 19 14:05:03 develop kernel: [<c10dbcd5>] ? fsnotify_put_group+0x70/0x77
Aug 19 14:05:03 develop kernel: [<c10dd8ec>] ? inotify_release+0x19/0x26
Aug 19 14:05:03 develop kernel: [<c10b3dfa>] ? __fput+0xd3/0x1ba
Aug 19 14:05:03 develop kernel: [<c10b3efc>] ? fput+0x1b/0x20
Aug 19 14:05:03 develop kernel: [<c10b108e>] ? filp_close+0x41/0x5f
Aug 19 14:05:03 develop kernel: [<c10342d5>] ? put_files_struct+0x68/0xa6
Aug 19 14:05:03 develop kernel: [<c103434a>] ? exit_files+0x37/0x3c
Aug 19 14:05:03 develop kernel: [<c1035777>] ? do_exit+0x146/0x6c6
Aug 19 14:05:03 develop kernel: [<c1035d27>] ? do_group_exit+0x30/0x85
Aug 19 14:05:03 develop kernel: [<c1035d8f>] ? sys_exit_group+0x13/0x17
Aug 19 14:05:03 develop kernel: [<c1003610>] ? sysenter_do_call+0x12/0x2c
Aug 19 14:05:03 develop kernel: Code: 89 04 24 8b 4d e8 8b 55 ec 89 f8 e8 5=
f=20
f9 ff ff 89 d8 e8 5d 4b fe ff eb 97 89 f0 e8 7d ee 25 00 8d 74 26 00 eb 8a =
90=20
90 55 89 e5 <0f> 0b eb fe 55 89 e5 e8 d6 09 00 00 5d c3 55 89 e5 53 89 c3 83
Aug 19 14:05:03 develop kernel: EIP: [<c10dd747>] idr_callback+0x3/0x7 SS:E=
SP=20
0068:f13c9e5c
Aug 19 14:05:03 develop kernel: ---[ end trace 0dbb2fea4568c322 ]---


=2D-=20
Linux User Group Wernigerode
http://www.lug-wr.de/

--nextPart2788521.HLxJi9iYJz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqL9K0ACgkQd9JRTD5SjRg58ACg2HNQRFfsWlSTlCAkHVlNCdTX
L7MAnRhLQD/sLQtO0G13C2JyA9B6wXx6
=iFrV
-----END PGP SIGNATURE-----

--nextPart2788521.HLxJi9iYJz--
