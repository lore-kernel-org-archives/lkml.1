Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbXJ1TZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbXJ1TZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 15:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbXJ1TZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 15:25:17 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:54726 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752327AbXJ1TZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 15:25:15 -0400
Date: Sun, 28 Oct 2007 20:25:28 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Greg KH <greg@kroah.com>, Simon Arlott <simon@fire.lp0.eu>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: eradicating out of tree modules
Message-ID: <20071028192528.GF7227@stusta.de>
References: <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk> <20071024223124.GI30533@stusta.de> <4721221A.1020309@imap.cc> <20071026025647.GC21408@kroah.com> <4721B77F.8070102@imap.cc> <20071026232653.GF30533@stusta.de> <47234F73.3040809@imap.cc> <20071028005555.GC23339@stusta.de> <4724DA20.1010609@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4724DA20.1010609@imap.cc>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 07:51:12PM +0100, Tilman Schmidt wrote:
> Am 28.10.2007 02:55 schrieb Adrian Bunk:
> > Justifying anything with code with not GPL compatible licences has zero 
> > relevance here.
> > 
> > And there's value in making life harder for such modules with 
> > questionable legality. As an example, consider people who experienced 
> > crashes of "the Linux kernel" caused by some binary-only driver.
> > Not that uncommon e.g. with some graphics drivers.
> > This harms the reputation of Linux as being stable.
> 
> You are mixing up several distinct categories here: "out of tree"
> != "non-GPL" != "proprietary" != "of questionable legality" !=
> "binary-only" != "causing kernel crashes".

"binary-only non-GPL out-of-tree module causes kernel crashes" is a 
quite common pattern for some popular binary-only modules.

And noone except the vendor of this module can debug and fix it.

Include more than one binary-only module into your kernel and the number 
of people being able to debug it might drop to zero.

> > The solution is not to support proprietary drivers, the solution is to 
> > get open source replacements.
> 
> So how do you propose to "get" those replacements? And what shall
> users do during the time this "getting" may take?

They should swamp the hardware vendors with requests for releasing 
hardware specifications.

Or even better buy their hardware from a competitor.

> > If it's low quality code doing something useful - well, how many hundred 
> > people are on Greg's list only waiting for some driver they could write?
> 
> No idea. Obviously not enough to actually solve the problem.

Greg has just begins with getting this started.

> What solution do you propose?

You list the drivers you currently have in mind at the Linux Driver 
Project [1].

> >> [D]o you think the world would
> >> be a better place if all the existing out-of-tree modules
> >> just ceased to exist, without any replacement?
> > 
> > With your "without any replacement" you needlessly excluded the 
> > reasonable solution:
> > 
> > The solution is that someone other than the author either takes the 
> > existing external code or rewrites it from scratch, submits it for 
> > inclusion into the kernel, and maintains it there.
> 
> My "without any replacement" is just a description of reality.
> All current external code I am aware of continues to exist only
> because there is no in-kernel replacement.
> 
> Again: how do you propose to bring that solution of yours to pass,

You list the drivers you currently have in mind at the Linux Driver
Project [1].

> how long do you think it will take, and what do you propose current
> users of out-of-tree modules do in the meantime?

Noone proposed to make the existance of out-of-tree modules completely 
impossible - but it is a fact that derives directly from the Linux 
kernel development model that thre's no stable API for out-of-tree 
modules, and therefore each new kernel breaks many of them.

Once you accept this fundamental fact there's not much point in arguing 
that changes that break out-of-tree modules should be fewer.

>...
> > Let me repeat that Greg has said he has hundreds of volunteers for such 
> > tasks.
> 
> Even with hundreds of volunteers, your proposed solution of just
> rewriting *all* external code in a way fit for inclusion into the
> kernel is an unachievable goal. Just look at the list on
> http://linuxdriverproject.org/twiki/bin/view/Main/OutOfTreeDrivers
> and try to answer why each of them is still out of tree.
> Hint: In most cases it's neither out of malice nor stupidity on
> the authors' part.

There are different problems why different drivers are not (yet) 
included in the kernel, but which ones don't have any possible solution?

And if you compare the numbers you'll see that Greg has on average a 
handful of volunteers for one driver.

> Of course in-tree code is always better than out-of-tree code. But
> I maintain there will always be out-of-tree code (modules, drivers,
> whatever) that fills a real need not (though hopefully, just not
> yet) satisfied by any in-tree code. All I'm asking for is that you
> take a pragmatic stance with regard to that: not going to any great
> lengths to support it, but acknowledging its existence and
> legitimacy - and not inciting to deliberately break it.

The most important question is still:

Why should there always be out-of-tree code that fills a real need not 
satisfied by any in-tree code?

Not everything might have worked in an ideal way in the past, but let's 
try to fix the problem, not let the problem justify workarounds.

> Thanks,
> Tilman

cu
Adrian

[1] http://linuxdriverproject.org

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

