Return-Path: <linux-kernel-owner+w=401wt.eu-S1752872Ab0AKIvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab0AKIvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 03:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832Ab0AKIvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 03:51:12 -0500
Received: from zbasel.fortytwo.ch ([193.138.215.60]:52968 "EHLO
	zbasel.fortytwo.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab0AKIvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 03:51:12 -0500
From: Adrian von Bidder <avbidder@fortytwo.ch>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: task imap:2958 blocked for more than 120 seconds
Date: Mon, 11 Jan 2010 08:34:36 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31-1-686; KDE/4.3.4; i686; ; )
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <201001102105.47192.johannes.hirte@fem.tu-ilmenau.de>
In-Reply-To: <201001102105.47192.johannes.hirte@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3876765.vYeTiJJ8uA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201001110834.36865@fortytwo.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3876765.vYeTiJJ8uA
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sunday 10 January 2010 21.05:46 Johannes Hirte wrote:
> I've observed this hanging task now several times. Not sure when this
>  started, but 2.6.32 is affected too, IIRC. I don't have a test pattern
>  for this. Dovecot imap triggers this from time to time. I've enabled
>  CONFIG_DETECT_HUNG_TASK now and got this two tasks which hang:

I've had vey similar hangs occasionally; don't remember if they were the=20
exact same code path or not.

"btrfs-vol -b" on an 2T btrfs fs (raid 1 mode over 4 disks) on an arm CPU=20
has triggered it several times, so it seems a reliable way to reproduce=20
this.

Unfortunately log rotation has already killed the messages.  Do you want me=
=20
to re-run?  2.6.32 kernel, btrfs-progs from git about 4 weeks ago.


cheers
=2D- vbi


=2D-=20
Place stamp here.

--nextPart3876765.vYeTiJJ8uA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: get my key from http://fortytwo.ch/gpg/92082481

iKcEABECAGcFAktK1IxgGmh0dHA6Ly9mb3J0eXR3by5jaC9sZWdhbC9ncGcvZW1h
aWwuMjAwMjA4MjI/dmVyc2lvbj0xLjUmbWQ1c3VtPTVkZmY4NjhkMTE4NDMyNzYw
NzFiMjVlYjcwMDZkYTNlAAoJECqqZti935l6SmwAoLEaqUxh+lKv6XodLxZMuiZ4
tyB+AJ4i+xIr0xINN56M3T29ZfIgD664HA==
=0lwA
-----END PGP SIGNATURE-----

--nextPart3876765.vYeTiJJ8uA--
