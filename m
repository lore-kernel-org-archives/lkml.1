Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbYAFT6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbYAFT6n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 14:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbYAFT6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 14:58:36 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53136 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041AbYAFT6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 14:58:35 -0500
Date: Sun, 6 Jan 2008 21:58:02 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Willy Tarreau <w@1wt.eu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       Peter Osterlund <petero2@telia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
Message-ID: <20080106195802.GN2082@does.not.exist>
References: <alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org> <m3ir27oe7f.fsf@telia.com> <1199627875.5205.1.camel@localhost.localdomain> <20080106144706.GA25419@elte.hu> <1199632845.5205.31.camel@localhost.localdomain> <20080106171158.GM20473@parisc-linux.org> <1199640983.5205.65.camel@localhost.localdomain> <20080106183402.GA7906@1wt.eu> <20080106185625.GM2082@does.not.exist> <20080106191044.GA1105@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080106191044.GA1105@1wt.eu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 08:10:44PM +0100, Willy Tarreau wrote:
> On Sun, Jan 06, 2008 at 08:56:25PM +0200, Adrian Bunk wrote:
> > On Sun, Jan 06, 2008 at 07:34:02PM +0100, Willy Tarreau wrote:
> > >...
> > > As to using bugzilla for bug tracking... Well, I agree that bug
> > > tracking is important when you work on multiple problems at once.
> > > But bugzilla should be the developer's tool, not the end user's.
> > > That means that it should only be our job to create entries there
> > > if end users find it too difficult, and that we should just invite
> > > them to *try* to report there to save us some time.
> > 
> > Where does this opinion end users would find Bugzilla too difficult come 
> > from? Many other projects use Bugzilla without big problems.
> > 
> > Is this just plain FUD or based on real reports from end users?
> > In the latter case, please give pointers to them so that whatever 
> > problems exist can be fixed.
> 
> I, as an end user of ntpd, have been harrassed to use it to get an
> ntp bug reported "because by mail it would get lost". What complicated

Noone knows how many thousand bug reports have never reached lkml 
since majordomo silently dropped them.

This is the price for having lkml relatively spam-free.

> an interface it is when you don't know it ! I remember I wanted to
> attach a patch and it didn't even get through the first time. I did
> it wrong. Blame me if you want, but an interface which need training
> for proper use is certainly not for casual end users.

What exactly is the problem with attaching files?
What is "it didn't even get through the first time" exactly?

> Also, it's very annoying to have to create an account somewhere, leaving
> there one of the passwords you use on many other sites, just to help a
> random developer fix a bug in his code. You quickly wonder if someone
> else will report it and have more patience.

If you already lack patience at this point, would you be willing to 
bisect which requires more than a dozen kernel recompiles and reboots?

> Another recent example: a coworker recently told me he installed the
> latest beta from ubuntu, and that he had some problems with his WIFI
> randomly hanging. I asked him if he filed a bug, he replied me "no,
> it's too much boring, I'm not the only one with this hardware, others
> have certainly already done it". When the release went out, he insisted
> telling me he was right not filing the bug because indeed it was fixed !

He wouldn't have sent a bug report no matter how to report it.

> We must accept that end users :
>   1) do not like creating accounts (remember or divulgate passwords,
>      and risk of getting spam)

Send _one_ email to lkml and you'll get forever spam to this address.

With one email addresses of mine exactly that happened.

>   2) do not know how to classify their problem, and are not even
>      sure it's a real bug. On the first page, when uncertain they
>      would probably click "Other". Adding doubt in the reporter's
>      mind is counter-productive as it will refrain him from being
>      precise about what he did to get the problem.

If the bug ends at Other/Other that's not a problem - this usually gets 
fixed within a few hours.

>   3) are not familiar with our vocabulary :
>      - "Tree" : mainline? mm? mjb? ac? what's that ?
>      - "Component" : Configuration? LSM? Modules? Other?

Then let's improve that.

>   => finally, I'm not sure I had to click "Other" in the first place,
>      I want to choose something else, I click "Back" and I get back
>      to the login page! Bye bye.

Works fine here.

Did you disable cookies?

> Also :
>   "No binary modules - NVIDIA users this means YOU!"
>    => about half the reporters will wonder if they should stop here
>       or not. Most of those with an NVidia chipset and/or graphics
>       card will wonder, while the bug may still interest us.

Then sugggest a better text.

> At least, on the mailing list, there's no real rules, the mail will
> be posted anyway. And if the user gets flamed, at least we have the
> report.
>...

If majordomo didn't drop it.

And if it didn't get ignored and forgotten.

> Regards,
> Willy

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

