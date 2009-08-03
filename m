Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbZHCThT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbZHCThT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 15:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbZHCThS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 15:37:18 -0400
Received: from mail-px0-f201.google.com ([209.85.216.201]:47529 "EHLO
	mail-px0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbZHCThR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 15:37:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=xsibD7Oc2UarCnjeomJE52cQlKm/soRGHpF4qZiR8s9OkLFS6Mf7768FwAe4b/fIvR
         5/ydqZ8GncfxBbjqW7Ab+T/3+65KQUOq0kQ1QTblVgPN4QzYaFoGOv9OX7b6gvUySenb
         FkM1efPrr9/qnbz076YjSZyxujvjXeXpTLtkE=
Message-ID: <4A773AC2.2080106@gmail.com>
Date: Mon, 03 Aug 2009 15:30:10 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH 7/7] venet: add scatter-gather/GSO support
References: <20090803171030.17268.26962.stgit@dev.haskins.net>	<20090803171807.17268.49836.stgit@dev.haskins.net> <20090803113225.4cd414ec@nehalam>
In-Reply-To: <20090803113225.4cd414ec@nehalam>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBE4790AD4B3E23612DA70C1F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBE4790AD4B3E23612DA70C1F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Stephen Hemminger wrote:
> On Mon, 03 Aug 2009 13:18:07 -0400
> Gregory Haskins <ghaskins@novell.com> wrote:
>=20
>> SG/GSO significantly enhance the performance of network traffic under
>> certain circumstances.  We implement this feature as a separate patch
>> to avoid intially complicating the baseline venet driver.  This will
>> presumably make the review process slightly easier, since we can
>> focus on the basic interface first.
>>
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>=20
> Never mind, previous comment about adding TSO.


I should probably fold 6+7 together anyway, so this was my fault.  I
think I was originally keeping them separate because the venet was
serving as the canonical example for the vbus interface.  But Ill just
come up with something simpler to demonstrate the interface and merge
these two patches.

> But it still would be good to have ethtool interface for this.

Ack.  Will do.

Thanks Stephen,
-Greg


--------------enigBE4790AD4B3E23612DA70C1F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkp3OsIACgkQP5K2CMvXmqGqYgCgh9VC2+3otM51psFaHNp8HUTe
h6oAn2gmbKCnW5Ip/KC2EfEp7rvhIEX8
=NES1
-----END PGP SIGNATURE-----

--------------enigBE4790AD4B3E23612DA70C1F--
