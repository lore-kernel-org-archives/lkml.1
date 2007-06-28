Return-Path: <linux-kernel-owner+w=401wt.eu-S1763694AbXF1GTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763694AbXF1GTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 02:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758194AbXF1GTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 02:19:31 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:37601 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163AbXF1GTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 02:19:30 -0400
Message-ID: <468352EC.2080704@kernel.org>
Date: Wed, 27 Jun 2007 23:19:24 -0700
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070531)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: "Serge E. Hallyn" <serge@hallyn.com>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <agm@google.com>, casey@schaufler-ca.com,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: implement-file-posix-capabilities.patch
References: <afff21250706110926l244ddc28i44289cb08a6721e2@mail.gmail.com> <20070617135239.GA17689@sergelap> <4676007F.7060503@kernel.org> <20070618044017.GW3723@sequoia.sous-sol.org> <20070620171037.GA28670@sergelap.ibm.com> <20070620174613.GF3723@sequoia.sous-sol.org> <20070621160011.GB9913@sergelap.austin.ibm.com> <467CD63B.4000703@kernel.org> <20070624155100.GA5167@vino.hallyn.com> <4681EED8.6050005@kernel.org> <20070627131654.GA2679@sergelap>
In-Reply-To: <20070627131654.GA2679@sergelap>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Serge E. Hallyn wrote:
>> Does that explain it?
> 
> Yes, thanks, but then it still could come in handy to have fE be a full
> bitset, so the application gets some eff caps automatically, while
> others it has to manually set...

[We touched on this a number of emails back.]

If an application is capability aware, it can manipulate its own
capabilities and should have fE=0.

If an application is not capability aware, it needs to have *all* of its
capabilities enabled at exec() time. Otherwise, it won't work.

The only reason for having an fE bitmap is to allow a capability-aware
program (you really trust to do its privileged operations carefully) to
be lazy and get some of its capabilities raised for free. Perhaps you
can clarify why this is a desirable thing? :-)

Cheers

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFGg1LqQheEq9QabfIRAo3BAKCO8QrfcKBNqhfnn2BHp8O/qDkgXgCgleEl
xP7LZPU9Qn6AjqI3ZM3FZ+4=
=urmz
-----END PGP SIGNATURE-----
