Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbYCNAIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbYCNAIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 20:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758233AbYCNAIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 20:08:21 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:60179 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752847AbYCNAIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 20:08:20 -0400
X-Sasl-enc: 0B4uH9OH4rhcq705TxovgVLyo5Oj18QB/FmlnOeQ0S9p 1205453299
Message-ID: <47D9C1F0.6050803@imap.cc>
Date: Fri, 14 Mar 2008 01:08:16 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Daniel Lezcano <dlezcano@fr.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       pekkas@netcore.fi, yoshfuji@linux-ipv6.org
Subject: Re: [2.6.25-rc5-mm1] regression: cannot run Postfix sendmail command
 as non-root
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <47D98510.60801@imap.cc> <47D9A8DF.30809@fr.ibm.com>
In-Reply-To: <47D9A8DF.30809@fr.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDD117BDCCEE25A8637BADD1B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDD117BDCCEE25A8637BADD1B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 13.03.2008 23:21 schrieb Daniel Lezcano:
> Tilman Schmidt wrote:

>> ts@xenon:~/kernel> /usr/sbin/sendmail -t < patch-usb-reduce-syslog-clu=
tter-v3
>> postdrop: warning: can't open /proc/net/if_inet6 (Permission denied) -=
 skipping IPv6 configuration
>> postdrop: fatal: parameter inet_interfaces: no local interface found f=
or ::1
>> sendmail: warning: command "/usr/sbin/postdrop -r" exited with status =
1
>> sendmail: fatal: ts(1000): unable to execute /usr/sbin/postdrop -r: Su=
ccess
>> ts@xenon:~/kernel>
>>
>> and unsurprisingly, the mail is not sent. If I do the same as root,
>> everything works as usual, there is no console output from the
>> sendmail command, and the mail goes out as it should. All other
>> networking applications appear to be running normally.

> Is it possible to have your config file used to compile the kernel ?

Sure. You can find it at
http://gollum.phnxsoft.com/~ts/linux/config-2.6.25-rc5-mm1

HTH
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigDD117BDCCEE25A8637BADD1B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH2cHwMdB4Whm86/kRAu7aAJ966Z+XoO5tWDEMqTeJu2PQ+DSjOwCfUTMO
3IpjhjI51hPVy0KIt11Srug=
=yXnI
-----END PGP SIGNATURE-----

--------------enigDD117BDCCEE25A8637BADD1B--
