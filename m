Return-Path: <linux-kernel-owner+w=401wt.eu-S1752427AbZJBRIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbZJBRIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbZJBRIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:08:44 -0400
Received: from mail-qy0-f173.google.com ([209.85.221.173]:52681 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbZJBRIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:08:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type;
        b=FmcezPbY1ddQWYgPdfDKpu4BNs5qXJjkJlZIHvBkcfz6Pa56TdF/WQuJbGhD8ZWjWM
         GVHPFxG1c7ePWWlQSGs+eFOaW3WIH/3ciuR0waLGGXfSmlNdK4JbZ6Qdf1vjIE65LRF3
         MJAnsTHatMe1EKPFp6VWCUAgw/QOh+eTMxhXU=
Message-ID: <4AC6339B.7000905@gmail.com>
Date: Fri, 02 Oct 2009 13:08:43 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Adding to linux-next?
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig89371A875C6DC069689EAD72"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig89371A875C6DC069689EAD72
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello Stephen, linux-next'ers,

I am looking for some guidance on policy/procedure governing inclusion
of a tree to linux-next.  For instance: Do I have to be arbitrarily
invited (e.g. by some committee on LKML), or do I explicitly request
consideration?  I tried to Google around for answers, and also found the
linux-next wiki, but I was not getting any clear answers.

I have these guest drivers to support IO on top of the AlacrityVM
hypervisor:

http://lkml.org/lkml/2009/8/3/278

The comments have since died down.  I realize this can mean anything
from "no objection" to "no interest" ;), but I assume the former unless
someone pipes up.

I believe I addressed the review comments and received an Ack from the
one maintainer of the tree that overlaps with the work (netdev/davem), he=
re:

http://lkml.org/lkml/2009/8/3/505

Since the rest of the work doesn't really fall into any existing
subsystem, and David conceded that the netdev overlap portion should
carry elsewhere, I offer to fill this role myself from within the
AlacrityVM tree itself.

As such, I have taken the driver series and created a new branch here:

git://git.kernel.org/pub/scm/linux/kernel/git/ghaskins/alacrityvm/linux-2=
=2E6.git
linux-next

Unlike the original posting, I have excluded the final ethernet patch
since I posted a v3 today (http://lkml.org/lkml/2009/10/2/239) that I
would like to have David re-Ack before including.

Once the driver has been suitably approved by David, and if he still
feels its ok to carry in a tree other than netdev, I will re-add it to
the linux-next branch.

Because I am not really sure of the policies for linux-next, let me
state my intentions of this branch, since I am an unknown in the
maintainership role:

I will only post patches to this branch that:

*) do not fall into an existing maintained subsystem category, unless
the appropriate maintainer has relinquished the patch to carry in my tree=
=2E
*) have previously been posted to LKML for suitable review.

IOW: The purpose is not to sneak something in, or subvert a maintained
subsystem.  It is purely to carry pieces that have no other home and are
maintained under the AlacrityVM project.  You can find more details of
the project here:

http://developer.novell.com/wiki/index.php/AlacrityVM

If this is not acceptable, or I need to follow some other procedure,
please advise me on the proper steps.  Perhaps I will update the wiki
FAQ on what I learn from your responses :)

Thank you, and Kind Regards,
-Greg


--------------enig89371A875C6DC069689EAD72
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrGM5sACgkQP5K2CMvXmqHkeQCcDvtdNuSIPKuXCv9dlxJ4xXFe
lccAnRh2ufxwKNPvhQw9KqoyPu5xNiKT
=ezHc
-----END PGP SIGNATURE-----

--------------enig89371A875C6DC069689EAD72--
