Return-Path: <linux-kernel-owner+w=401wt.eu-S1759979AbXJXV35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979AbXJXV35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755793AbXJXV3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:29:45 -0400
Received: from web36605.mail.mud.yahoo.com ([209.191.85.22]:39510 "HELO
	web36605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755679AbXJXV3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:29:44 -0400
X-YMail-OSG: Es.04woVM1kv8W2wOX19NCfDz7VjWbZSuuuRh6gmWv8W5hRLGsULq7jTPklYpHYcJSK8Rw_Lvg--
X-RocketYMMF: rancidfat
Date: Wed, 24 Oct 2007 14:29:43 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static interface)
To: Crispin Cowan <crispin@crispincowan.com>
Cc: Simon Arlott <simon@fire.lp0.eu>, Adrian Bunk <bunk@kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0710242232260.17781@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <252801.14025.qm@web36605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



I have written Smack.
I need an LSM infrastructure.
I would prefer the old dynamic version.
I no trouble with the static version.

I think that a dynamic version is more useful, but I didn't want
what I'm doing to have it as a dependency, so I made sure that
it isn't. The debate about the inclusion of Smack can remain
blissfully separate from the dynamic/static LSM debate. This is
by design.

I have had a couple people suggest changes to Smack that would be
very elegently handled as stacked modules. These include "owned"
ports and additional uid restrictions. Since Smack is a MAC module
these other security features are not really appropriate to include
(if you want the Security Monolith there is SELinux) in it, but
certainly make sense to combine with it.

A stacker that does not require module participation could be quite
interesting. In the old day I felt that a security solution had to
include all aspects of control, but today I see the value provided
by independent mechanisms such as IPtables.



Casey Schaufler
casey@schaufler-ca.com
