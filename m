Return-Path: <linux-kernel-owner+w=401wt.eu-S1760642AbYCXQze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbYCXQze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 12:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbYCXQz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 12:55:26 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39846 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbYCXQzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 12:55:25 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] kbuild: silence documentation GEN xml messages according to $(quiet)
Date: Mon, 24 Mar 2008 12:57:56 -0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org
References: <1206371815-32376-1-git-send-email-vapier@gentoo.org> <20080324090939.73f8b00b.randy.dunlap@oracle.com>
In-Reply-To: <20080324090939.73f8b00b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6512548.23NLaBYjRh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200803241257.57183.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6512548.23NLaBYjRh
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 24 March 2008, Randy Dunlap wrote:
> On Mon, 24 Mar 2008 11:16:55 -0400 Mike Frysinger wrote:
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> > ---
> >  Documentation/DocBook/Makefile |    5 ++++-
> >  1 files changed, 4 insertions(+), 1 deletions(-)
> >
> > diff --git a/Documentation/DocBook/Makefile
> > b/Documentation/DocBook/Makefile index 300e170..f6a4ba3 100644
> > --- a/Documentation/DocBook/Makefile
> > +++ b/Documentation/DocBook/Makefile
> > @@ -186,8 +186,11 @@ quiet_cmd_fig2png =3D FIG2PNG $@
> >
> >  ###
> >  # Rule to convert a .c file to inline XML documentation
> > +       gen_xml =3D :
> > + quiet_gen_xml =3D echo '  GEN     $@'
> > +silent_gen_xml =3D :
> >  %.xml: %.c
> > -	@echo '  GEN     $@'
> > +	@$($(quiet)gen_xml)
> >  	@(                            \
> >  	   echo "<programlisting>";   \
> >  	   expand --tabs=3D8 < $< |     \
> > --
>
> The Makefile changes are good, but the patch description makes it
> appear that Mike was rushed.  How about something like this?

i just copied & pasted the previous commit messages for similar fixes.  you=
r=20
longer version sounds fine to me though.
=2Dmike

--nextPart6512548.23NLaBYjRh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUAR+fdlUFjO5/oN/WBAQL+7xAAuIUrSauLvOn3kU/PmG6dDJK+/+de/BhN
iMcvVOxNOFUDbhUM+rTrnx/Le13RdShgVIdNM/sLHmCSOsIK8kDt1buxjd9sPE2D
zuhtUgqxYuXy6101BfmFHKIuuACVqa3iJ4z8iR3/YkW5oxgYcAMWeAipEQMgNKsS
hFfqQk1N4UYODVZJve0yLFMu7FNX3QRmO6I3cg0Zs0ZBtl1V0dslSdjiWhIQs4q1
9WXxx4xbZ+1F7PnsbKNofYghZjwdFkpVL7WpfLxw8l7nC6hoF0rZ6fnI1E06IP0W
WLZzcJIY+en2O63ogqrgUXzlK36Him35aHkOKmSv9fA5yfd4gsfS27TqbAG4CCGi
XQYtIT96ZIkuEglZCSW4bujvtkdSw20BAs7aIi2+jbT6qE74LEwd65sEuR2/Adhe
ydwLV6rG+kRdGqsgcIGzebTnF3DXquP6Oda67BfmGsJkh9Ez/hJ6H4t3hm/Z63Hr
pVSXGEm++kc2UVKUcSmsrY+6YlPY3svoEOXsFMcO32Fs9jZV0rP8bb2AuSJzbMcd
5HZZD/7wUTnj/drMHaKJEeTuj7/+APToJSM+UTiKFAiDEQi74Jfqmyc4oVUEiWRu
ZmP6X4obs1zKFuSAGiT1aIQ801Rc1vTzRs0RCxuSGyjRBAUtTqikFaeBAplmHobC
phrHbVSyCig=
=aHMO
-----END PGP SIGNATURE-----

--nextPart6512548.23NLaBYjRh--
