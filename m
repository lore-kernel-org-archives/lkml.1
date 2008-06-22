Return-Path: <linux-kernel-owner+w=401wt.eu-S1753620AbYFVNHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbYFVNHm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 09:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbYFVNHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 09:07:32 -0400
Received: from mx1-2.mail.ru ([194.67.23.121]:26102 "EHLO mx1.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751516AbYFVNHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 09:07:31 -0400
X-Greylist: delayed 133390 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Jun 2008 09:07:31 EDT
From: Andrew Savchenko <Bircoph@list.ru>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: Re: [RFC/PATCH] ipg: add jumbo frame support kconfig option
Date: Sun, 22 Jun 2008 17:07:14 +0400
User-Agent: KMail/1.9.1
Cc: Stephen Hemminger <stephen.hemminger@vyatta.com>,
       linux-kernel@vger.kernel.org, Francois Romieu <romieu@fr.zoreil.com>,
       Linux Netdev List <netdev@vger.kernel.org>, shemminger@vyatta.com,
       Jeff Garzik <jeff@garzik.org>, sorbica@icplus.com.tw,
       Jesse Huang <jesse@icplus.com.tw>
References: <200806201037.46687.Bircoph@list.ru> <20080620084131.3313abe8@speedy> <Pine.LNX.4.64.0806221220540.27261@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0806221220540.27261@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2568399.13LfdU9z0l";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200806221707.22348.Bircoph@list.ru>
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2568399.13LfdU9z0l
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

On Sunday 22 June 2008 13:23, Pekka J Enberg wrote:
> On Fri, 20 Jun 2008, Stephen Hemminger wrote:
> > The code should enable/disable anything it needs based on the
> > MTU size in the change_mtu call. If the driver needs to
> > reallocate buffers, change receiver settings, make sacrifices
> > to deities, or phone home that is the place to do it. In other
> > words no compile or config option fro MTU settings please.
>
> Right, so how about something like this instead? Andrew, can you
> test the following patch? You need all the other patches from
> the previous series modulo the last patch. Thanks!

Ok, I replaced old ipg-make-jumbo-frame-support-configurable with=20
newer version. It works fine, I tuned MTU in the range from 68 to=20
10240 bytes )).

Thanks for the patch, awaiting for it in the main kernel tree.

Sincerely yours,
Andrew

--nextPart2568399.13LfdU9z0l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBIXk6CAvwbVeyQBdURArAmAKCRcgxVAJn+wEGFOOH8FuNmTdulawCdHlmn
zR/5FbhIghjw+WMnQGVLtUQ=
=DacC
-----END PGP SIGNATURE-----

--nextPart2568399.13LfdU9z0l--
