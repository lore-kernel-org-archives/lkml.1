Return-Path: <linux-kernel-owner+w=401wt.eu-S1753109AbZIZVfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbZIZVfy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 17:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbZIZVfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 17:35:51 -0400
Received: from mail-gx0-f212.google.com ([209.85.217.212]:64200 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbZIZVfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 17:35:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A41atCi6wU+ejhkqP1HNIp5tqk3FZe9gsTlm6dv/cCjAirwKV++1fzFDLRMn0RQXjN
         gO09P7ukDrNVsCwv7iIAeamh8yzf655YsC0NxLakSuMu1egHfx2AV18477/KoHxB+Rir
         Z2ITmI3vPqsvIQLA/YMKuCPONgLkh2w7Zn03k=
Date: Sat, 26 Sep 2009 21:35:28 +0000
From: Andy Spencer <andy753421@gmail.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Privilege dropping security module
Message-ID: <20090926213528.GB23564@c.hsd1.tn.comcast.net>
References: <20090923005644.GA28244@c.hsd1.tn.comcast.net>
 <20090923213109.GA936@c.hsd1.tn.comcast.net>
 <4ABB9D6D.8000607@schaufler-ca.com>
 <20090925100630.GD10098@c.hsd1.tn.comcast.net>
 <4ABCEE71.6060703@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_c-23790-1254000952-0001-2"
Content-Disposition: inline
In-Reply-To: <4ABCEE71.6060703@schaufler-ca.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_c-23790-1254000952-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> It's amazing who much of this stuff there is to attend to.  If you
> haven't, run checkpatch.py on your patches. You'll need to pass that
> eventually.

I've fixed the remaining things that checkpatch.pl suggests as well as a
few others and will include those checks for future patches.


> Hmm. You are working with the Linux DAC mechanism, even if only within
> a process tree. You're not dropping privilege, you're applying a mask
> to the file permission bits, currently for file system objects, and
> with other objects (sysvipc at least) in the future. Hmm. modemask?
> Something derived from "restricted process tree?"

`Access Control Masking' or `Policy Masking' perhaps?


> You will need to change that if you want the code upstream. There are
> people lurking out there, looking for things that could be static be
> aren't and pouncing on unwary developers.

I noticed that `make namespacecheck' complained about that as well, so I
went ahead and make those static.


> Please repost against the mainline.  I will look at the semantics of
> the code next time around.

I'll repost in a couple days once I've worked in a few more suggestions.
(and hopefully with a new name)

--=_c-23790-1254000952-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkq+iTgACgkQz1OYJ/s1XTCEHQCfebpsBj4co/KF/vtvrMfp1cVR
DJAAoL9qpInjtK1XPDwT9rjTvBkbou82
=ehl4
-----END PGP SIGNATURE-----

--=_c-23790-1254000952-0001-2--
