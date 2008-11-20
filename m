Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbYKTGtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbYKTGtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 01:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbYKTGsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 01:48:55 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:52936 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbYKTGsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 01:48:54 -0500
Subject: Re: WARNING: at net/mac80211/rx.c:388
	__ieee80211_rx_handle_packet+0x1fe/0x627 [mac80211]()
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Schulte <cs@schulte.it>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <20081119165329.15e5a6d4.akpm@linux-foundation.org> (sfid-20081120_015353_985468_5559E0F5)
References: <4922D9D5.2020507@schulte.it>
	 <20081119165329.15e5a6d4.akpm@linux-foundation.org>
	 (sfid-20081120_015353_985468_5559E0F5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-THb/KqtDV+KvMdW/HgOC"
Date: Thu, 20 Nov 2008 07:48:18 +0100
Message-Id: <1227163698.17336.12.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-THb/KqtDV+KvMdW/HgOC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-19 at 16:53 -0800, Andrew Morton wrote:
> (cc linux-wireless)
>=20
> On Tue, 18 Nov 2008 16:05:57 +0100
> Christian Schulte <cs@schulte.it> wrote:
>=20
> > this is with the 2.6.27.6 iwl3945 module. Is it some misconfiguration o=
n
> > my side ?

Yes.

config MAC80211_DEBUG_PACKET_ALIGNMENT
        bool "Enable packet alignment debugging"  =20
        depends on MAC80211_DEBUG_MENU=20
        ---help---
          This option is recommended for driver authors and strongly
          discouraged for everybody else, it will trigger a warning
          when a driver hands mac80211 a buffer that is aligned in
          a way that will cause problems with the IP stack on some
          architectures.

          Say N unless you're writing a mac80211 based driver.


> > Nov 15 21:45:35 r60 kernel: WARNING: at net/mac80211/rx.c:388 __ieee802=
11_rx_handle_packet+0x1fe/0x627 [mac80211]()
> > Nov 15 21:45:35 r60 kernel: Modules linked in: ipt_MASQUERADE iptable_n=
at nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables x_tables binfmt_misc fgl=
rx(P) rfcomm l2cap uinput ipv6 ppdev parport_pc lp parport dm_snapshot dm_m=
irror dm_log dm_mod sbp2 loop pcmcia hci_usb joydev arc4 ecb crypto_blkciph=
er battery bluetooth ac bay video output psmouse yenta_socket rsrc_nonstati=
c serio_raw iwl3945 pcmcia_core mac80211 cfg80211 button snd_hda_intel snd_=
pcm snd_seq snd_timer snd_seq_device rng_core i2c_i801 snd iTCO_wdt pcspkr =
intel_agp soundcore snd_page_alloc agpgart evdev xfs sd_mod crc_t10dif ide_=
cd_mod cdrom ata_generic ata_piix ahci libata usbhid piix hid ohci1394 ide_=
core scsi_mod ff_memless ieee1394 dock tg3 libphy thermal fan ohci_hcd uhci=
_hcd ehci_hcd usbcore radeonfb fb_ddc i2c_algo_bit i2c_core acpi_cpufreq fr=
eq_table processor thermal_sys thinkpad_acpi rfkill led_class nvram
> > Nov 15 21:45:35 r60 kernel: Pid: 11033, comm: clamd Tainted: P         =
 2.6.27.6-workstation #1
> > Nov 15 21:45:35 r60 kernel:  [<c0123d26>] warn_on_slowpath+0x40/0x63
> > Nov 15 21:45:35 r60 kernel:  [<f9684817>] ieee80211_wep_decrypt_data+0x=
72/0x81 [mac80211]
> > Nov 15 21:45:35 r60 kernel:  [<c02caa65>] __lock_text_start+0x2d/0x33
> > Nov 15 21:45:35 r60 kernel:  [<c026166b>] skb_queue_tail+0x11/0x2d
> > Nov 15 21:45:35 r60 kernel:  [<f968ee00>] ieee80211_rx_irqsafe+0x2c/0x4=
f [mac80211]
> > Nov 15 21:45:35 r60 kernel:  [<f975dc90>] iwl3945_pass_packet_to_mac802=
11+0x260/0x272 [iwl3945]
> > Nov 15 21:45:35 r60 kernel:  [<f968f410>] ieee80211_rx_h_data+0x26/0x62=
 [mac80211]
> > Nov 15 21:45:35 r60 kernel:  [<f9690a0c>] __ieee80211_rx_handle_packet+=
0x1fe/0x627 [mac80211]
> > Nov 15 21:45:35 r60 kernel:  [<f9691529>] __ieee80211_rx+0x48e/0x4f9 [m=
ac80211]
> > Nov 15 21:45:35 r60 kernel:  [<f9750ca2>] iwl3945_rx_queue_restock+0x9a=
/0x117 [iwl3945]

Intel doesn't care to make their drivers work on platforms that don't
like unaligned loads, so in the foreseeable future this warning will
show once if you enable that option above that specifically tells you to
turn it off.....

johannes

--=-THb/KqtDV+KvMdW/HgOC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJJQgvAAoJEKVg1VMiehFYrMoP/iXK75WRQ1Er2TKTj5KJrpib
AivxeeG+6uzOsVcdyeLfeZxtT3pTGEE8YpOWtuZb9PuuM8DbWVZOQ+Ep8mV1YRDZ
UqYxJf56xPagZx/KATrlZ0A7h6Blf3u5vMZxQBK5Wg5LDBVW1gLxEyqyLdYUwNhY
jhhlnKnTUj3KXCz8sizbzHSzLmke0wEeMieOMCJSHgNcGDEV1Tve2ALeqnhrXNGJ
WceBVztud9BxJCpGca95XmPasABbNTQg4O7LEZK+2qotwHvum8nk+o2aYD2eJoTW
AE5cDJHylu8P0a+NKjmcBS5O3Cd3yGs/75UI5p5WB9o4cKOmbAv9N3x0UVgJ2IeG
yaJpN/i//AiV/KZupgtLuK0s217YGMIv/Q2f1yERTkN2Lhq8AaCA6L/swvyUUKep
W8UL/SrpJow/2sxxXLILVxWIltNyN2rNcO82fvd3w6Mvmfj+mUjpxsq4essC73YB
rSTKYNqQh3j4RN+M4Jhp3UIkOXsg9XIns7KnhDJmOf1lP/hb27ZLVXv+qEE26P5d
j0RtKCfZiWnecsykVcKdZe4GAQELn6iwnfe8Os63GmTjqV24BANKVOE2dlC20fTs
dN+U1/u7H7swQPHlxOHMRCxCa2IM5msadfW2UBmBxeqZe0pmglnXE1pyQUeo1Daa
fK23rtO5O1FP08StOX2Y
=p+so
-----END PGP SIGNATURE-----

--=-THb/KqtDV+KvMdW/HgOC--

