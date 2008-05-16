Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbYEPQP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbYEPQP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbYEPQPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:15:46 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:37544 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbYEPQPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:15:45 -0400
Subject: Re: [PATCH 1/67] aufs document
From: Dave Quigley <dpquigl@tycho.nsa.gov>
To: hooanon05@yahoo.co.jp
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <18952.1210952732@jrobl>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp>
	 <1210949976.14706.28.camel@moss-terrapins.epoch.ncsc.mil>
	 <18952.1210952732@jrobl>
Content-Type: text/plain
Date: Fri, 16 May 2008 12:09:12 -0400
Message-Id: <1210954152.14706.50.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-05-17 at 00:45 +0900, hooanon05@yahoo.co.jp wrote:
> Hello Dave,
> Thank you for your comments.
> 
> About diffstat, actually I send it but the subject was not 0/67.
> Please read the thread whose subject is
> "[RFC n/2] AUFS: merging/stacking several filesystems"
> The last message in the thread which I sent just before the patch series
> has diffstat.
> Do you want me to re-send it after changing the subject line?

You don't have to resend it now. Just keep it in mind for future patch
set submissions.

> 
> About the number of patches, I have to agree it is large. I chose the
> way to make a patch per a new file, and in case of modifying the
> existing multiple files I made a single patch. I guess the latter is the
> case you wrote "can be folded."

Yea in some cases this is possible. You could roll all headers into one
patch. Or you could roll a header and its corresponding source into a
patch. There are many ways to do it. 

> 
> About the description, simple one for the new files because they are
> brand new... I wrote a little more in case of modifying the existing
> files (see the last patch). Of course a more detail description will be
> necessary in future modification.
> If you think the functionality is obscure, please read the aufs
> documents included in the patch set (the first patches).
> 

It is fine to have an overall document describing your FS but there are
things you have missing. For example patch 62. Why do you have magic
sysreq handling? What does it do? What problem is it solving? This isn't
in your 01 patch and I can't tell its purpose at all from the patch.

Another example is what are your sysfs entries for? A description of
what they are for in either the main doc or as a patch comment is
necessary. Why is your sysfs functionality broken out into two patches?

There are many other things like this. I must admit our initial release
of Unionfs wasn't any better in terms of patch descriptions. Also our
patch set was smaller since we removed some functionality we knew would
be resisted by upstream and because our file layout is different from
yours. However like the sysfs patches being broken up there are a couple
of other things that represent one logical set that can be grouped
together.


The point of posting these sets to LKML is so people will review them.
If I have to read through a large document and then through each patch
individually just to figure out what the patch is trying to accomplish
before I can see how it is going about accomplishing it, then that is
extra resistance to actually looking through the set.

Dave 

> Junjiro Okajima
> 
> 
> Dave Quigley:
> > A couple of comments about this. First off you might want to reconsider
> > how you are breaking up the patches. 67 patches seems a bit much to me
> > and while the separation between patches is clear it seems that some of
> > them can be folded. Second I'm not sure if I haven't gotten it yet or if
> > it wasn't sent but I am missing an Email 0/67. Typically this contains a
> > description of the patch set, an index of the patches (possibly with
> > descriptions), and a diffstat for the entire patch set. The last thing
> > is that each patch should have You could break up the patches by functionality likea worth wile description attached to it.
> > All of your comments are two lines and that may make sense based on how
> > you have it broken up but if you start breaking up the patch set
> > differently you will need better descriptions (possibly even now for
> > some of the more obscure functionality).

