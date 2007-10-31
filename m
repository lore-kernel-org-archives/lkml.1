Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbXJaEUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbXJaEUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 00:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbXJaEUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 00:20:41 -0400
Received: from mx40.mail.ru ([194.67.23.36]:57879 "EHLO mx40.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbXJaEUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 00:20:40 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.24: (ACPI AC adapter) sending {proc,netlink,kobject}_event from -> resume method?
Date: Wed, 31 Oct 2007 07:20:36 +0300
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Alexey Starikovskiy <astarikovskiy@suse.de>
References: <200710302233.31791.arvidjaar@mail.ru> <200710302228.25650.rjw@sisk.pl>
In-Reply-To: <200710302228.25650.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1271587.NisnTc7COA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710310720.37185.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1271587.NisnTc7COA
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 31 October 2007, Rafael J. Wysocki wrote:
> On Tuesday, 30 October 2007 20:33, Andrey Borzenkov wrote:
> > Is it valid to send events from within ->resume device method?
>
> It is or at least it should be.  The GPEs are supposed to be fully
> functional at this point.
>
> > If not, what is the proper way to notify user space about hardware
> > changes during suspension?
> > Specifically it seems that new sysfs ACPI power supply interface
> > sometimes missing plugged in AC cord during suspend. I suspect that no
> > event is generated for this; I am not sure whether ACPI is required to
> > generate such events at all in this case.
> >
> > I'll need some time to get reproducible case so I do not categorize this
> > yet as regression.
>
> Is the "[2.6.24-rc1 regression] AC adapter state does not change after
> resume" message a follow-up to this one?
>

yes

--nextPart1271587.NisnTc7COA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHKAKVR6LMutpd94wRAnNYAJ9YC7jaqhLjt0Ums+UXAOc/zA1IkgCfbZ7j
Bmzmbn9h+j1ifeDtfqyMpo0=
=U0Kb
-----END PGP SIGNATURE-----

--nextPart1271587.NisnTc7COA--
