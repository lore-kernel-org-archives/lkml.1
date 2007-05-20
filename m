Return-Path: <linux-kernel-owner+w=401wt.eu-S1759618AbXETQJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618AbXETQJv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 12:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757346AbXETQJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 12:09:44 -0400
Received: from mx34.mail.ru ([194.67.23.200]:32189 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756518AbXETQJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 12:09:43 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
Date: Sun, 20 May 2007 20:09:38 +0400
User-Agent: KMail/1.9.6
Cc: "Al Viro" <viro@ftp.linux.org.uk>, "Uwe Bugla" <uwe.bugla@gmx.de>,
       "Ken Chen" <kenchen@google.com>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
References: <464F42F3.1080300@madrabbit.org> <20070520062816.GA4095@ftp.linux.org.uk> <2c0942db0705200822j685ec3b2x399a080622b6fc05@mail.gmail.com>
In-Reply-To: <2c0942db0705200822j685ec3b2x399a080622b6fc05@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1242151.tPIGQWa9H6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705202009.39291.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1242151.tPIGQWa9H6
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sunday 20 May 2007, Ray Lee wrote:
> On 5/19/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> > On Sat, May 19, 2007 at 11:16:59PM -0700, Ray Lee wrote:
> > > Ken? Ball's in your court. As the patch isn't providing a killer
> > > feature for 2.6.22, I'd suggest just reverting it for now until the
> > > issues are ironed out.
> >
> > Hold it.  The real question here is which logics do we want there.
> > IOW, and how many device nodes do we want to appear and _when_ do
> > we want them to appear?
>
> The when part is what looks to make it racy. I'm guessing that we're
> relying on udev to create those loop nodes. If so, I think any scheme
> that creates more on demand would give transient mount errors while
> it's waiting on udev to create more nodes.
>

this seems to work with /dev/pts though. May be, by accident?

--nextPart1242151.tPIGQWa9H6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGUHLDR6LMutpd94wRAu2fAKCeDhjHti7u4282DXag+uoRz8H5TgCgjTAM
lQlA+0jp/sRAkL77doQxfMg=
=Pw7p
-----END PGP SIGNATURE-----

--nextPart1242151.tPIGQWa9H6--
