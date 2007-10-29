Return-Path: <linux-kernel-owner+w=401wt.eu-S1760092AbXJ2TFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092AbXJ2TFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbXJ2TFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:05:30 -0400
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1529 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbXJ2TF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:05:29 -0400
X-Greylist: delayed 32551 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2007 15:05:28 EDT
Message-ID: <10965.80.126.27.205.1193684677.squirrel@webmail.xs4all.nl>
Date: Mon, 29 Oct 2007 20:04:37 +0100 (CET)
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to      
     static interface)
From: "Rob Meijer" <capibara@xs4all.nl>
To: "Crispin Cowan" <crispin@crispincowan.com>
Cc: rmeijer@xs4all.nl, casey@schaufler-ca.com,
       "Chris Wright" <chrisw@sous-sol.org>, "Adrian Bunk" <bunk@kernel.org>,
       "Simon Arlott" <simon@fire.lp0.eu>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andreas Gruenbacher" <agruen@suse.de>,
       "Thomas Fricaccia" <thomas_fricacci@yahoo.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "James Morris" <jmorris@namei.org>,
       "Giacomo Catenazzi" <cate@debian.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Reply-To: rmeijer@xs4all.nl
User-Agent: SquirrelMail/1.4.11
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, October 29, 2007 11:24, Crispin Cowan wrote:

>> Thus IMHO it may be a good idea to instead of a maintainer for LSM
>> modules as proposed, alternatively a maintainer for each formal model
>> may be more appropriate. This also would require module builders to
>> first
>> think about what formal model they are actualy using, thus resulting in
>> cleaner module design.
>>
> I *really* dislike this idea. It seems to set up the situation that the
> only acceptable modules are those that follow some "formal" model.
> Problems:
>
>     * What qualifies as a formal model? This becomes an arbitrary litmus
>       test, depending on whether the model was originally published in a
>       sufficiently snooty forum.
>     * What if someone invents a new model that has not been "formalized"
>       yet? Should Linux be forced to wait until the idea has been
>       through the academic mill before we allow someone to try
>       implementing a module for the idea?

I may have been stating things a bit to strong when talking only about
"formal" models only. But possibly you could just define the non-formal
experimental models as a single group.

The thing I was trying to propose was aimed at the problem that if someone
proposes a patch to the LSM base code that he/she feels is needed to
complete an LSM module that implements a particular (formal) model,
he/she would end up explaining and/or defending both the 'model', the module
and its requirement for the patch.

What I tried to propose is to assign some sort of maintainer role for each
(formal) model, and let these roles take care of the module/patch part of
stuff, while the module writer would only need to defend/discuss the the
patch with the model maintainer.

>     * The proposal only allows a single implementation of each formal
>       model. In theory, theory is just like practice, but in practice it
>       is not. SMACK and SELinux follow substantially similar formal
>       models (not exactly the same) so should we exclude one and keep
>       the other? No, of course not, because in practice they are very
>       different.

I would think the two may benefit from a role as described above.
But I was thinking more in the line of new modules that may again
implement this same model, and would thus benefit from interaction with
this 'model maintainer' role.


Rob

