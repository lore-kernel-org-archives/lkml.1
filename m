Return-Path: <linux-kernel-owner+w=401wt.eu-S1757131AbXJ2KYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131AbXJ2KYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 06:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbXJ2KYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 06:24:11 -0400
Received: from mail8.dotsterhost.com ([66.11.233.1]:40442 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752388AbXJ2KYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 06:24:10 -0400
Message-ID: <4725B4EA.4060303@crispincowan.com>
Date: Mon, 29 Oct 2007 03:24:42 -0700
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: rmeijer@xs4all.nl
CC: casey@schaufler-ca.com, Chris Wright <chrisw@sous-sol.org>,
       Adrian Bunk <bunk@kernel.org>, Simon Arlott <simon@fire.lp0.eu>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to   
   static interface)
References: <15466.80.126.27.205.1193652063.squirrel@webmail.xs4all.nl>
In-Reply-To: <15466.80.126.27.205.1193652063.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Meijer wrote:
> What may be even more relevant are those concepts that couldn't be done
> in SELinux, and how proposals that come from the theory of alternative
> access controll models (like object capability modeling) are dismissed
> by the aparently largely MLS/MAC oriented people on the list.
Clearly what is needed here is for someone to actually implement an
object capability LSM module. None of SELinux, SMACK, LIDS, AppArmor,
MultiADM, or TOMOYO can implement object capabilities, so there is clear
justification for building such a module. I would argue strongly to
include it.

> Thus IMHO it may be a good idea to instead of a maintainer for LSM
> modules as proposed, alternatively a maintainer for each formal model
> may be more appropriate. This also would require module builders to first
> think about what formal model they are actualy using, thus resulting in
> cleaner module design.
>   
I *really* dislike this idea. It seems to set up the situation that the
only acceptable modules are those that follow some "formal" model. Problems:

    * What qualifies as a formal model? This becomes an arbitrary litmus
      test, depending on whether the model was originally published in a
      sufficiently snooty forum.
    * What if someone invents a new model that has not been "formalized"
      yet? Should Linux be forced to wait until the idea has been
      through the academic mill before we allow someone to try
      implementing a module for the idea?
    * The proposal only allows a single implementation of each formal
      model. In theory, theory is just like practice, but in practice it
      is not. SMACK and SELinux follow substantially similar formal
      models (not exactly the same) so should we exclude one and keep
      the other? No, of course not, because in practice they are very
      different.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
CEO, Mercenary Linux		   http://mercenarylinux.com/
	       Itanium. Vista. GPLv3. Complexity at work

