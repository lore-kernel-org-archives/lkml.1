Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbXJ2FRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbXJ2FRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 01:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbXJ2FRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 01:17:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37525 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbXJ2FRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 01:17:15 -0400
Date: Sun, 28 Oct 2007 22:12:14 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Crispin Cowan <crispin@crispincowan.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray-lk@madrabbit.org>,
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
Message-ID: <20071028221214.171f7d3a@laptopd505.fenrus.org>
In-Reply-To: <47250878.6040506@crispincowan.com>
References: <20071024223124.GI30533@stusta.de>
	<446110.89443.qm@web36608.mail.mud.yahoo.com>
	<20071025002356.GB3660@sequoia.sous-sol.org>
	<2c0942db0710241735j78cfbec9rd8b5128d5da1fb96@mail.gmail.com>
	<20071025024131.6082e4a8@the-village.bc.nu>
	<47250878.6040506@crispincowan.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007 15:08:56 -0700
Crispin Cowan <crispin@crispincowan.com> wrote:

> To reject an LSM for providing "bad" security, IMHO you should have to
> show how it is possible to subvert the self-stated goals of that LSM.
> Complaints that the LSM fails to meet some goal outside of its stated
> purpose is irrelevant. Conjecture that it probably can be violated
> because of $contrivance is just so much FUD.

exactly; this is why I've been pushing recently for each new LSM to at
least document and make explicit what it tries to protect / protect
against (threat model and defense model in traditional security terms).
Without such an explicit description it's both impossible to
"neutrally" review a proposed LSM towards its goals, and it ends up as
a result with people making assumptions and attacking the model because
there's no separation between code and model.

 
> Exception: it is valid to say that the self-stated goal is too narrow
> to be useful. But IMHO that bar of "too narrow" should be very, very
> low. Defenses against specific modes of attack would be a fine thing
> to build up in the library of LSMs, especially if we got a decent
> stacking module so that they could be composed.

again I agree pretty much; I do want to reserve some minimum "common
sense" bar because people may (and probably will) do silly things withs
LSMs that are really not the right thing to do objectively.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
