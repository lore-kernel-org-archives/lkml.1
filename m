Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbYJLJIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbYJLJIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 05:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYJLJIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 05:08:12 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:19000 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbYJLJIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 05:08:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=s7Ys9OoEwp14cFW0KJaq/yvV/93RMkiNkWfn2bNvITng1qUvG1mDRv/mJOf/GAsGJS
         L4eQXYlHZtUsfOXEXtDilQ9g6tyNQ15WNh+NNulVsP2/jllRGob9HlJ74who66uNuno0
         MAMId1bTbzMC7d4StV/uCpDOYCSWWomEleeEM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH 0/7] ide: locking improvements
Date: Sun, 12 Oct 2008 11:05:39 +0200
User-Agent: KMail/1.9.10
Cc: Jens Axboe <jens.axboe@oracle.com>, petkovbb@gmail.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <fa.Ke90oacfRjgiI4x5LejzjssRBEg@ifi.uio.no> <200810112046.23557.bzolnier@gmail.com> <48F1552F.7090600@shaw.ca>
In-Reply-To: <48F1552F.7090600@shaw.ca>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810121105.39318.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 October 2008, Robert Hancock wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > The work has already been done and it is a wortwhile work.  The risk is
> > quite low (this is the statement based on rather deep understanding of
> > IDE subsystem, the complete audit of all code-paths affected and all the
> > testing experiences from Scalex86/me).
> > 
> > Moreover the patch won't be merged after few months of extra testing.
> > 
> > I feel that you still keep on questioning the point of improving IDE
> > and insist on putting it into "bug-fixes only" mode.  If this is really
> > the case I'm completely uninterested in discussing it any further.
> 
> What, exactly, is the point of making more than bug-fix-only changes to 

Please stop this bug-fix-only nonsense already.

Take a look at the bug #11581.  I posted the link in my reply to Jens
because it is a best example that bug-fix-only mode won't really guarantee
a stable, bug-free code in the long-term.  Many of issues at such level
as driver subsystems happen because of "collateral damage" caused by
changes at the higher level.

[ The fact that #11581 was bisected to Jens' commit is just an additional
  spice.  It is likely that bisection went wrong but with git-bisect you
  are guilty-until-proven-innocent so Jens please (finally) help us with
  resolving it. ]

Additionally with open-source projects you have to keep a certain level
of developers' interests because otherwise everybody will be bored to
death and go away work on some other things (unless of course they are
paid to actually work on bugfixes).  Which in turn will result in less
people reviewing changes or doing bugfixes.

IOW in the long-term bug-fix-only code will result in less stable code.

> the IDE code today, when we have libata around which is a much better 
> code base to work from? I'm afraid it still escapes me. I don't mean to 

Simply:

* Not all hardware is supported by libata.

* Today's IDE code is not so different from libata's.

* I'm much more familiar with IDE's code than libata's. :)

> denigrate the work that you and other people working on IDE are doing, 
> but can't help but think there would be more productive outlets for it..

I don't really care.  I work on IDE because it is _fun_.

Thanks,
Bart
