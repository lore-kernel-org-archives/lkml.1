Return-Path: <linux-kernel-owner+w=401wt.eu-S1763601AbXEYU2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763601AbXEYU2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 16:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162AbXEYU14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 16:27:56 -0400
Received: from web36609.mail.mud.yahoo.com ([209.191.85.26]:31963 "HELO
	web36609.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754671AbXEYU1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 16:27:55 -0400
X-YMail-OSG: HYBv9awVM1kDWO6gFkIfiGuM.AXQ4HLf8I6cX11T3cNiw2v2E3ByD1W1BoJ0OGuVaFlMjAYQwA--
X-RocketYMMF: rancidfat
Date: Fri, 25 May 2007 13:27:54 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <200705252200.21765.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <312681.33492.qm@web36609.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andreas Gruenbacher <agruen@suse.de> wrote:

> On Friday 25 May 2007 19:43, Casey Schaufler wrote:
> > [...] but the AppArmor code could certainly check for that in exec by
> > enforcing the argv[0] convention. It would be perfectly reasonable for a
> > system that is so dependent on pathnames to require that.
> 
> Hmm ... that's a strange idea.

Yeah, I get that a lot.

> AppArmor cannot assume anything about argv[0],
> 
> and it would be a really bad idea to change the well-established semantics of
> 
> argv[0].
> 
> There is no actual need for looking at argv[0], though: AppArmor decides
> based 
> on the actual pathname of the executable...

Right. My point was that if you wanted to use the gzip/gunzip
example of a file with two names being treated differently based
on the name accessed as an argument for AppArmor you could. If
you don't want to, that's ok too. Jeremy raised a reasonable objection,
and AppArmor could address it if y'all chose to do so. I seriously
doubt that enforcing the argv[0] convention would break much, and I
also expect that if it did there's a Consultant's Retirement to be
made fixing the security hole it points out.


Casey Schaufler
casey@schaufler-ca.com
