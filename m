Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbXEZW7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbXEZW7F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 18:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbXEZW6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 18:58:53 -0400
Received: from web36612.mail.mud.yahoo.com ([209.191.85.29]:22489 "HELO
	web36612.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750800AbXEZW6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 18:58:51 -0400
X-YMail-OSG: VVwIecMVM1nsFKOz1uVG0qEEATbQvq_F2IyZ0h3qlectrzuh1_YSYGwSu6t9JrKOTGRGvgZ13Q--
X-RocketYMMF: rancidfat
Date: Sat, 26 May 2007 15:58:50 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
To: Andreas Gruenbacher <agruen@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <200705261410.19541.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <990795.7773.qm@web36612.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andreas Gruenbacher <agruen@suse.de> wrote:

> On Friday 25 May 2007 21:06, Casey Schaufler wrote:
> > --- Jeremy Maitin-Shepard <jbms@cmu.edu> wrote:
> > > ...
> > > Well, my point was exactly that App Armor doesn't (as far as I know) do
> > > anything to enforce the argv[0] convention,
> >
> > Sounds like an opportunity for improvement then.
> 
> Jeez, what argv[0] convention are you both talking about?

>From the exec(3) man page:

   "The first argument, by convention, should point to the
    file name associated with the file being executed."

since the man page calls it a convention, so do I.

> argv[0] is not guaranteed to have any association with the
> name of the executable. Feel free to have any discussion
> about argv[0] you want, but *please* keep it away from
> AppArmor, which really has nothing to do with it.

As I pointed out, if you wanted to trust the argv[0] value
(which I understand AppArmor makes no claims about) and you
wanted to use the argv[0] value to determine application
behavior (which several people claim is a Bad Idea) you could
use Name Based Access Control to provide different access
to the common binary. As I pointed out before, that's a lot
of "if's".

> It would be nice if you could stop calling argv[0] checks ``name-based access
> 
> control'': from the point of view of the kernel no access control is 
> involved, and even application-level argv[0] based access control makes no 
> sense whatsoever.
 
Fair enough, I don't believe that an argv[0] check ought to
be used as a security mechanism. I am not convinced that everyone
would agree with us.



Casey Schaufler
casey@schaufler-ca.com
