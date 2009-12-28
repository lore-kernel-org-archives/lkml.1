Return-Path: <linux-kernel-owner+w=401wt.eu-S1751970AbZL1V1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbZL1V1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 16:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbZL1V1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 16:27:13 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:44423 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbZL1V1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 16:27:11 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Michael Stone <michael@laptop.org>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: RFC: disablenetwork facility. (v4)
In-Reply-To: Your message of "Mon, 28 Dec 2009 11:31:09 EST."
             <20091228163108.GC13266@heat>
From: Valdis.Kletnieks@vt.edu
References: <20091228163108.GC13266@heat>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1262035489_4431P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 28 Dec 2009 16:24:49 -0500
Message-ID: <14145.1262035489@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020204.4B392223.0098,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1262035489_4431P
Content-Type: text/plain; charset=us-ascii

On Mon, 28 Dec 2009 11:31:09 EST, Michael Stone said:

> > Actually it does. Policy may well be "If the network works, noone can
> > log in locally, because administration is normally done over
> > network. If the network fails, larger set of people is allowed in,
> > because something clearly went wrong and we want anyone going around
> > to fix it."
> 
> Have you actually seen this security policy in real life? I ask because it
> seems quite far-fetched to me. Networks are just too easy to attack. Seems to
> me, from this casual description, that you're just asking to be ARP- or
> DNS-poisoned and rooted with this one.

Actually, I've seen a *lot* of similar "if things fail, more people can login
to fix it" policies.  For instance, a default Fedora box will require a root
password to login - but if you can't get to multi-user because the box is
scrozzled and boot into single user, no root password is required.

So if you're using Fedora and LDAP authentication, and reboot to single-user
to fix an LDAP issue, you do in fact have that policy in real life...

(And before you start shouting "but that's a stupid config to make root login
depend on LDAP", note that for many Microsoft Active Directory shops, they add
machines with Administrator rights for an Active Directory group, and then
disable local Administrator, which is exactly the same thing...  Stupid or
not, it's a *very* common policy.)


--==_Exmh_1262035489_4431P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLOSIhcC3lWbTT17ARAgF0AJoDigVJ9mt3CDqRFsu0uX9a8tpYewCeNvKT
5W8Pmh/BccabcO7s/2p9ymk=
=xP2S
-----END PGP SIGNATURE-----

--==_Exmh_1262035489_4431P--

