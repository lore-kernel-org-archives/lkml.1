Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbZIZVKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbZIZVKY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 17:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZIZVKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 17:10:21 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:58980 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbZIZVKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 17:10:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WYXIvD+a/O+u6+43oVO3fKQz8eJXz9JhGTrrl6Cci9YnIFkCSwYu4smI8rlKuhb7am
         BXGmPWueznr6NovzFzBhe1yVdqDAhcE+TSWqsl1vg2/hotpDeUJ8eYpjJPx2qR/F8mS9
         PUUiNDVbAFNci6DlPlyVAS2PgH0K4u/Vw2fA8=
Date: Sat, 26 Sep 2009 21:09:58 +0000
From: Andy Spencer <andy753421@gmail.com>
To: David Wagner <daw-news@cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Privilege dropping security module
Message-ID: <20090926210958.GA23564@c.hsd1.tn.comcast.net>
References: <20090923005644.GA28244@c.hsd1.tn.comcast.net>
 <20090923223110.GA1449@c.hsd1.tn.comcast.net>
 <h9g795$9om$1@taverner.cs.berkeley.edu>
 <20090925072248.GB9821@c.hsd1.tn.comcast.net>
 <h9jaar$url$1@taverner.cs.berkeley.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_c-23638-1253999422-0001-2"
Content-Disposition: inline
In-Reply-To: <h9jaar$url$1@taverner.cs.berkeley.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_c-23638-1253999422-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> As a result, in practice this interface to dpriv probably means that
> most implemented policies will be more permissive than
> intended/desired.  I consider that a defect in the design of the
> specification language.  It seems like it would be preferable to have
> a specification language that better facilitates secure use of dpriv.

What would you suggest as a better specification language? Would it be
sufficient to have recursive and non recursive variants for masking
permissions?

There's an implementation problem with using recursive permissions and
expanding * in userspace as well. If the user allows access to `foo' and
denies access to `foo/*', and later creates new entry of `foo/bar', the
new entry would have access allowed, which would probably not reflect
the users intent.

--=_c-23638-1253999422-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkq+gz4ACgkQz1OYJ/s1XTAUKQCfaQEwcHD4HSsnTXic1siJ8tCu
6q4AoMKhtUggucGVfZHWuoWGH0vCMVv4
=HGm7
-----END PGP SIGNATURE-----

--=_c-23638-1253999422-0001-2--
