Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbZCOCGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbZCOCGI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 22:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbZCOCFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 22:05:54 -0400
Received: from b01.ext.isohunt.com ([208.71.112.51]:60387 "EHLO
	mail.isohunt.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751635AbZCOCFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 22:05:54 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Mar 2009 22:05:53 EDT
Date: Sat, 14 Mar 2009 14:39:47 -0700
From: "Robin H. Johnson" <robbat2@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: robbat2@gentoo.org
Subject: rmmod/delete_module hangs forever
Message-ID: <20090314213947.GA9084@curie-int>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

(Please CC me on responses).

I've been meaning to report this for quite some time, but haven't got to it.

I think it may be as a result of some driver that's loaded, rather than the
core, as running the git tip (0556e82 and on another machine at home and I
can't reproduce it there.

I'm going to try a bisect shortly, and I'll post a followup thereafter.

Strace gives me this fun in the end:
delete_module("button", O_RDONLY|O_EXCL|O_NONBLOCK
and it just sits there.
=20
Linux bohr-int 2.6.29-rc7-00188-gebdcc81 #35 SMP Thu Mar 12 03:41:55 PDT 20=
09 x86_64 Intel(R) Core(TM)2 Quad CPU Q9550 @ 2.83GHz GenuineIntel GNU/Linux
=20
Gnu C                  4.3.3
Gnu make               3.81
binutils               2.19.1
util-linux             2.14.2
mount                  support
module-init-tools      3.6
e2fsprogs              1.41.4
jfsutils               1.1.13
reiserfsprogs          3.6.21
xfsprogs               3.0.0
quota-tools            3.17.
PPP                    2.4.4
Linux C Library        2.9
Dynamic linker (ldd)   2.9
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.15
Sh-utils               7.1
wireless-tools         29
Modules Loaded         loop btusb wacom nfs coretemp uinput af_packet bondi=
ng ipv6 cpufreq_ondemand bridge stp llc bnep rfcomm l2cap bluetooth snd_seq=
_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss sn=
d_mixer_oss reiserfs xfs dm_mod nvram hangcheck_timer pciehp pci_hotplug nf=
sd lockd nfs_acl auth_rpcgss sunrpc exportfs cpufreq_stats acpi_cpufreq fre=
q_table w83627ehf hwmon_vid snd_hda_codec_atihdmi snd_hda_codec_analog fire=
wire_ohci firewire_core crc_itu_t snd_hda_intel snd_hda_codec ata_generic s=
nd_hwdep mptspi snd_pcm ohci1394 mptscsih pata_acpi i2c_i801 ahci iTCO_wdt =
snd_timer thermal pcspkr ieee1394 i2c_core mptbase iTCO_vendor_support liba=
ta snd evdev sg processor sky2 rtc_cmos soundcore scsi_transport_spi rtc_co=
re snd_page_alloc tpm_infineon thermal_sys intel_agp tpm rtc_lib tpm_bios b=
utton hwmon ext2 scsi_wait_scan ohci_hcd usb_storage sd_mod crc_t10dif

--=20
Robin Hugh Johnson
Gentoo Linux Developer & Infra Guy
E-Mail     : robbat2@gentoo.org
GnuPG FP   : 11AC BA4F 4778 E3F6 E4ED  F38E B27B 944E 3488 4E85

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)
Comment: Robbat2 @ Orbis-Terrarum Networks - The text below is a digital signature. If it doesn't make any sense to you, ignore it.

iEYEARECAAYFAkm8JCMACgkQPpIsIjIzwiwpDQCfUPrL1QHGnQhLlNW5gRhqvMJR
ypgAoMrK0JIFyZXwlVzYIaf2woew671A
=pQMT
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
