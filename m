Return-Path: <linux-kernel-owner+w=401wt.eu-S1760401AbYCGDTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760401AbYCGDTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 22:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756187AbYCGDTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 22:19:11 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45564 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989AbYCGDTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 22:19:10 -0500
Date: Fri, 7 Mar 2008 14:18:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for March 7
Message-Id: <20080307141856.b27d1725.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__7_Mar_2008_14_18_56_+1100_7=r+_VZv6pvInlSv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Mar_2008_14_18_56_+1100_7=r+_VZv6pvInlSv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
(tar balls at
http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
allmodconfig for both powerpc and x86_64.

There were a few merge conflicts (trivial) and one build break.  I have
notified the appropriate people.

We are up to 44 trees, more are welcome (even if they are currently
empty).  The influx of new trees has been underwhelming.  Thanks to those
who have contributed, and to those who haven't, please do.

Status of my local build tests is at
http://kisskb.ellerman.id.au/kisskb/branch/9/.  If maintainers want to
give advice about cross compilers/configs that work, we are always open
to add more builds.  Build results from today on also include the actual
compiler version string.

It looks like this one is going to build fail the same way as yesterday's t=
ree:

drivers/usb/core/hub.c:633: error: 'struct usb_device' has no member named =
'persist_enabled'
drivers/usb/core/hub.c:719: error: 'struct usb_device' has no member named =
'reset_resume'

for any config with CONFIG_PM disabled.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__7_Mar_2008_14_18_56_+1100_7=r+_VZv6pvInlSv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH0LQnTgG2atn1QN8RAge2AJ44YEebk28N6uOuRwtfY/yej7PfSQCfWyan
Ao6aavUal30comKN0dq4uzo=
=Fept
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Mar_2008_14_18_56_+1100_7=r+_VZv6pvInlSv--
