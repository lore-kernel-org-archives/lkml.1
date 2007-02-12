Return-Path: <linux-kernel-owner+w=401wt.eu-S964964AbXBLPUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964964AbXBLPUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 10:20:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964966AbXBLPUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 10:20:49 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:53296 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964964AbXBLPUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 10:20:46 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-scsi@vger.kernel.org
Subject: Re: [GIT PATCH] SCSI updates for 2.6.20
Date: Mon, 12 Feb 2007 16:21:18 +0100
User-Agent: KMail/1.9.6
Cc: James Bottomley <James.Bottomley@steeleye.com>,
       Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Hannes Reinecke <hare@suse.de>
References: <1171166252.3373.58.camel@mulgrave.il.steeleye.com> <200702121129.34359.eike-kernel@sf-tec.de> <1171291120.3690.0.camel@mulgrave.il.steeleye.com>
In-Reply-To: <1171291120.3690.0.camel@mulgrave.il.steeleye.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4633436.Lx5QbtJ5KU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702121621.31232.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4633436.Lx5QbtJ5KU
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

James Bottomley wrote:
> On Mon, 2007-02-12 at 11:29 +0100, Rolf Eike Beer wrote:
> > Am Sonntag, 11. Februar 2007 schrieb James Bottomley:
> > > This is the accumulated SCSI tree for 2.6.20.  It is available at
> > >
> > > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> >
> > You once again have not included this two patches Andrew sent you on
> > 20070602:
> >
> > [patch 08/33] remove extra newline from info message
>
> This one's waiting on Hannes to ack, since he's working in that driver

Ah, thanks. (Added Hannes to CC).

> > [patch 09/33] Fix scsi/scsi_transport.h compile error
>
> I did look at this one, but I can't find a configuration that will
> induce a compile error like the header says.  It's pending further
> investigation.

Just try to compile a file that only includes this header. I don't know if=
=20
there is an existing (in-kernel) configuration where this can go wrong, I=20
found it when hacking a replacement for cpqfcTS. Nevertheless this is still=
 a=20
bug, relying on a specific include order is just wrong.

Greetings,

Eike

--nextPart4633436.Lx5QbtJ5KU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBF0IX7XKSJPmm5/E4RAkVfAJ422voSn0nhm9CBZ4aeZXZ0MsT8ewCfUDNt
XPHBOla9YYPL7PMUnDoIJ4w=
=aZH9
-----END PGP SIGNATURE-----

--nextPart4633436.Lx5QbtJ5KU--
