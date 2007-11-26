Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbXKZUwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbXKZUwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 15:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbXKZUv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 15:51:56 -0500
Received: from smtp118.sbc.mail.re3.yahoo.com ([66.196.96.91]:22328 "HELO
	smtp118.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752518AbXKZUvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 15:51:54 -0500
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Nov 2007 15:51:54 EST
X-YMail-OSG: Q6Weh3wVM1kXwR0wd2w_it.z4qPfHjIvSPavcThtbwz_4c7VLAZxo_Tg5enS4fY6afJt7qzYFw--
Date: Mon, 26 Nov 2007 14:42:20 -0600
From: serge@hallyn.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Crispin Cowan <crispin@crispincowan.com>, Ray Lee <ray-lk@madrabbit.org>,
       Chris Wright <chrisw@sous-sol.org>,
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
Message-ID: <20071126204216.GA19259@vino.hallyn.com>
References: <20071024223124.GI30533@stusta.de> <446110.89443.qm@web36608.mail.mud.yahoo.com> <20071025002356.GB3660@sequoia.sous-sol.org> <2c0942db0710241735j78cfbec9rd8b5128d5da1fb96@mail.gmail.com> <20071025024131.6082e4a8@the-village.bc.nu> <47250878.6040506@crispincowan.com> <20071028225044.3471f88b@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071028225044.3471f88b@the-village.bc.nu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(finally starting to make headway through this thread over a month late)

Quoting Alan Cox (alan@lxorguk.ukuu.org.uk):
> > To reject an LSM for providing "bad" security, IMHO you should have to
> > show how it is possible to subvert the self-stated goals of that LSM.
> > Complaints that the LSM fails to meet some goal outside of its stated
> > purpose is irrelevant. Conjecture that it probably can be violated
> > because of $contrivance is just so much FUD.
> 
> That seems to be an appropriate test.
> 
> > Exception: it is valid to say that the self-stated goal is too narrow to
> > be useful. But IMHO that bar of "too narrow" should be very, very low.
> > Defenses against specific modes of attack would be a fine thing to build
> > up in the library of LSMs, especially if we got a decent stacking module
> > so that they could be composed.
> 
> Once you have stacking then it actually at times will make sense to have
> security modules that do one very precise thing and do it well.

Hey - I thought it was the other way around?  :)

-serge
