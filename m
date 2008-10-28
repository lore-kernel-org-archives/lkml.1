Return-Path: <linux-kernel-owner+w=401wt.eu-S1753262AbYJ1QWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbYJ1QWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 12:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbYJ1QWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 12:22:24 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36301 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbYJ1QWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 12:22:23 -0400
Date: Tue, 28 Oct 2008 11:21:59 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Howells <dhowells@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml <linux-kernel@vger.kernel.org>, jmorris@us.ibm.com
Subject: Re: [PATCH] User namespaces: set of cleanups (v2)
Message-ID: <20081028162159.GA15342@us.ibm.com>
References: <20081024174838.GA24466@us.ibm.com> <20081025130531.ca063206.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081025130531.ca063206.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Rothwell (sfr@canb.auug.org.au):
> Hi Serge,
> 
> On Fri, 24 Oct 2008 12:48:38 -0500 "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> >
> > would you mind applying the patch below behind
> > git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/cred-2.6.git#creds-v3?
> > 
> > Assuming David has no objections?
> > 
> > I've just tested with David's plain creds-v3 tree and had no problems.
> > (compiled with CONFIG_USER_NS=y|n and CONFIG_KEYS=y|n, boot+ltp with
> > both =y)
> > 
> > Or would it fit your model better if I found a place to keep a quilt
> > patchset or git tree?
> 
> Better if you can set up a git tree (or quilt series) somewhere as I
> intend to only carry fixup patches myself in linux-next (so far).  Also
> that means when you update your patches, I will just fetch them
> automatically.

The tree is up at:

git://git.kernel.org/pub/scm/linux/kernel/git/sergeh/userns-2.6#next

with just two patches on top of David's creds-v4.

> If this stuff depends on David's work, then I need to know that
> explicitly so I can do ordering.  If it depends closely (i.e. changes in

Yes it belongs after his creds-v4 tree.

> Davids tree need to be reflected in yours) then you and David need to
> come to some arrangement (maybe David could host your tree as a branch of
> his (managing conflicts/updates).

I don't know how many additional changes David plans to make in the near
future.  Assuming he makes them in creds-v4 and not in a new tree I
guess I'll feel the pain but that's how it goes.

Any additional userns patches would likely be feature enhancements and
I don't expect to get them in any kindo f merge-worthy shape before
2.6.29 is out.

thanks,
-serge
