Return-Path: <linux-kernel-owner+w=401wt.eu-S933142AbZHDRY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142AbZHDRY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 13:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932896AbZHDRY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 13:24:27 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:56990 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932915AbZHDRY0 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 13:24:26 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Eric Paris <eparis@redhat.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "malware-list@dmesg.printk.net" <malware-list@dmesg.printk.net>,
       "greg@kroah.com" <greg@kroah.com>, "jcm@redhat.com" <jcm@redhat.com>,
       Douglas Leeder <douglas.leeder@sophos.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "david@lang.hm" <david@lang.hm>,
       "jengelh@medozas.de" <jengelh@medozas.de>,
       "aviro@redhat.com" <aviro@redhat.com>,
       "mrkafk@gmail.com" <mrkafk@gmail.com>,
       "alexl@redhat.com" <alexl@redhat.com>, "jack@suse.cz" <jack@suse.cz>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
       "hch@infradead.org" <hch@infradead.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "mmorley@hcl.in" <mmorley@hcl.in>, "pavel@suse.cz" <pavel@suse.cz>
Subject: Re: fanotify - overall design before I start sending patches
In-Reply-To: Your message of "Tue, 04 Aug 2009 12:27:48 EDT."
             <1249403268.2361.21.camel@dhcp231-106.rdu.redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <1248466429.3567.82.camel@localhost> <200908041709.51659.tvrtko.ursulin@sophos.com>
            <1249403268.2361.21.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1249406551_4151P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 04 Aug 2009 13:22:31 -0400
Message-ID: <19585.1249406551@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1249406551_4151P
Content-Type: text/plain; charset=us-ascii

On Tue, 04 Aug 2009 12:27:48 EDT, Eric Paris said:
> On Tue, 2009-08-04 at 17:09 +0100, Tvrtko Ursulin wrote:
> > Would it make more sense to deny on timeouts and then evict? I am thinking it
> > would be more secure with no significant drawbacks. Also for usages like HSM
> > allowing it without data being in place might present wrong content to the
> > user.
>
> I'd be willing to go that route as long as noone else complains.

Yes, in my world, "deny on timeout and evict" is the better design decision.
For an HSM, you'd rather have a quick-and-ugly death on a failed file open than
an app accidentally reading the HSM's stub data thinking it's the original data.

--==_Exmh_1249406551_4151P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKeG5XcC3lWbTT17ARAgTaAJwMJpFQHwG6kpTzufnNGwkpaqFOxgCbBUnR
ifyZGbthA+r4NEMya8+W3LE=
=VEO0
-----END PGP SIGNATURE-----

--==_Exmh_1249406551_4151P--
