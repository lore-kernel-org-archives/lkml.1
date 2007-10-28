Return-Path: <linux-kernel-owner+w=401wt.eu-S1756418AbXJ1XMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbXJ1XMi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 19:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbXJ1XMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 19:12:20 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54928 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753921AbXJ1XMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 19:12:19 -0400
Date: Sun, 28 Oct 2007 22:50:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Crispin Cowan <crispin@crispincowan.com>
Cc: Ray Lee <ray-lk@madrabbit.org>, Chris Wright <chrisw@sous-sol.org>,
       Casey Schaufler <casey@schaufler-ca.com>, Adrian Bunk <bunk@kernel.org>,
       Simon Arlott <simon@fire.lp0.eu>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Giacomo Catenazzi <cate@debian.org>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to
 static interface)
Message-ID: <20071028225044.3471f88b@the-village.bc.nu>
In-Reply-To: <47250878.6040506@crispincowan.com>
References: <20071024223124.GI30533@stusta.de>
	<446110.89443.qm@web36608.mail.mud.yahoo.com>
	<20071025002356.GB3660@sequoia.sous-sol.org>
	<2c0942db0710241735j78cfbec9rd8b5128d5da1fb96@mail.gmail.com>
	<20071025024131.6082e4a8@the-village.bc.nu>
	<47250878.6040506@crispincowan.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> To reject an LSM for providing "bad" security, IMHO you should have to
> show how it is possible to subvert the self-stated goals of that LSM.
> Complaints that the LSM fails to meet some goal outside of its stated
> purpose is irrelevant. Conjecture that it probably can be violated
> because of $contrivance is just so much FUD.

That seems to be an appropriate test.

> Exception: it is valid to say that the self-stated goal is too narrow to
> be useful. But IMHO that bar of "too narrow" should be very, very low.
> Defenses against specific modes of attack would be a fine thing to build
> up in the library of LSMs, especially if we got a decent stacking module
> so that they could be composed.

Once you have stacking then it actually at times will make sense to have
security modules that do one very precise thing and do it well.

Alan
