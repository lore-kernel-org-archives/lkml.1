Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172Ab0ANHD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab0ANHD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 02:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009Ab0ANHDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 02:03:55 -0500
Received: from zbasel.fortytwo.ch ([193.138.215.60]:60215 "EHLO
	zbasel.fortytwo.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab0ANHDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 02:03:54 -0500
From: Adrian von Bidder <avbidder@fortytwo.ch>
To: Chris Mason <chris.mason@oracle.com>
Subject: Re: task imap:2958 blocked for more than 120 seconds
Date: Thu, 14 Jan 2010 08:03:43 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31-1-686; KDE/4.3.4; i686; ; )
Cc: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
       linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201001102105.47192.johannes.hirte@fem.tu-ilmenau.de> <201001110945.32352@fortytwo.ch> <20100114010829.GE3428@think>
In-Reply-To: <20100114010829.GE3428@think>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2528838.qedlu2ZzfK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201001140803.48506@fortytwo.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2528838.qedlu2ZzfK
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Heyho!

On Thursday 14 January 2010 02.08:29 Chris Mason wrote:
> On Mon, Jan 11, 2010 at 09:45:31AM +0100, Adrian von Bidder wrote:
> > On Monday 11 January 2010 08.34:36 Adrian von Bidder wrote:
> > > "btrfs-vol -b" on an 2T btrfs fs (raid 1 mode over 4 disks) on an arm
> > >  CPU  has triggered it several times, so it seems a reliable way to
> > >  reproduce this.
> >
> > Found it (Debian kernel 2.6.32 on ARM):
> >
> > [78260.386272] INFO: task btrfs-vol:10979 blocked for more than 120
> > seconds. [78260.386306] "echo 0 >
> > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [78260.386331] btrfs-vol     D c02b080c     0 10979      1 0x00000001
> > [78260.386373] [<c02b080c>] (schedule+0x424/0x488) from [<c02b0c9c>]
> > (schedule_timeout+0x1c/0x244) [78260.386408] [<c02b0c9c>]
> > (schedule_timeout+0x1c/0x244) from [<c02b0b10>]
> > (wait_for_common+0xdc/0x178) [78260.386611] [<c02b0b10>]
> > (wait_for_common+0xdc/0x178) from [<bf29b880>]
> > (merge_reloc_roots+0x15c/0x1a4 [btrfs]) [78260.386940] [<bf29b880>]
> > (merge_reloc_roots+0x15c/0x1a4 [btrfs]) from [<bf2a3fd8>]
> > (relocate_block_group+0x548/0x5c8 [btrfs])
>=20
> Blocking here isn't a huge surprise, relocation can involve some long
> held locks.  Does this recover?

Yes, always so far.

cheers
=2D- vbi

=2D-=20
Tomorrow we have important delivery and this afternoon out Japanese
colleagues decided that 2000 pages describing our software solution is
not enough. They need at least 500 extra pages. Fortunately it could be
any existing documentation, so we randomly choose POSIX standard Part 1
(535 pages) and the Eclipse basic tutorial (592 pages).
        -- Michal =C4=8Ciha=C5=99

--nextPart2528838.qedlu2ZzfK
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: get my key from http://fortytwo.ch/gpg/92082481

iKcEABECAGcFAktOwc9gGmh0dHA6Ly9mb3J0eXR3by5jaC9sZWdhbC9ncGcvZW1h
aWwuMjAwMjA4MjI/dmVyc2lvbj0xLjUmbWQ1c3VtPTVkZmY4NjhkMTE4NDMyNzYw
NzFiMjVlYjcwMDZkYTNlAAoJECqqZti935l624sAn1ZbGrIaTMArvRKOMwzV76qS
OA2NAJ4gkSngsR+ljj8MDEPw3Fbdi8Y3vA==
=C/U2
-----END PGP SIGNATURE-----

--nextPart2528838.qedlu2ZzfK--
