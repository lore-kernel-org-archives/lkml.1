Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbZJAJQC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbZJAJQC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 05:16:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbZJAJQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 05:16:00 -0400
Received: from mail-yx0-f173.google.com ([209.85.210.173]:63135 "EHLO
	mail-yx0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345AbZJAJP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 05:15:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oBWGrjmbSolSZDJLvbAY7BqMULGAMlMvCz/lm7WaYfSVH/19hhzU/bqUhDSaZsKrd3
         33+E/JR3KexR5jL+dCr9uvQSv716z1sXl5rkLZx7v6BHMf3Ra33Hi1PKworPrni8sR1a
         wL994V6EIje+RmINg38JLfF1XpfnsMZA0a8j4=
Date: Thu, 1 Oct 2009 09:15:37 +0000
From: Andy Spencer <andy753421@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Privilege dropping security module
Message-ID: <20091001091537.GA22337@c.hsd1.tn.comcast.net>
References: <20090923005644.GA28244@c.hsd1.tn.comcast.net>
 <4ABA892A.9090804@schaufler-ca.com>
 <20090923223110.GA1449@c.hsd1.tn.comcast.net>
 <20091001073853.GA1330@ucw.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_c-23052-1254388561-0001-2"
Content-Disposition: inline
In-Reply-To: <20091001073853.GA1330@ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_c-23052-1254388561-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> Yeah, and now your ~/.ssh/identity is being uploaded to remote server.

The given policy sets the home directory (including ~/.ssh/) to `X'
which does not include read access, so ~/.ssh/identity should be safe.
There are some other problems with this particular policy though, /tmp/
is still readable for example.


> I believe people are already sandboxing apps with selinux...

Yes, some people (including myself) are already using selinux, tomoyo,
smack, etc, for sandboxing. However, I think those have some
disadvantages that I'm trying to address.


> ...and subterfugue certainly does what you want, using ptrace... no
> kernel mods needed and should already be secure.

subterfugue does look interesting, but it seems like it would be pretty
slow and hasn't been unmaintained since 2001.

--=_c-23052-1254388561-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkrEc1EACgkQz1OYJ/s1XTBUHQCg18HZmf7LsyTYZov1in9ff+Tm
Y8EAn0wBtU3V+kCpJp/Pz3a20gYKkKvc
=WV0a
-----END PGP SIGNATURE-----

--=_c-23052-1254388561-0001-2--
