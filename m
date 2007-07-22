Return-Path: <linux-kernel-owner+w=401wt.eu-S1763422AbXGVTMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763422AbXGVTMT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 15:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762171AbXGVTMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 15:12:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:7200 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760526AbXGVTMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 15:12:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sgscq7kiajna4XRvanq5CvmvqzJ/tKCcxedOuOaVZzDDlfNK4EgqRheJzl8gQcfhEMuZWU0Xhx3JIeRjDxxQgLNTvvZ/0yaNmMAc7T53WlduoldB8pz8IzHLp6aVeWBoKDuQ2aSbyzrp3pLuqj7kaFP09r3AQlVc6BKAHy5HWCk=
Message-ID: <9e4733910707221212v2f6cc1c4kf7a35e84f351e4cd@mail.gmail.com>
Date: Sun, 22 Jul 2007 15:12:03 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Git help for kernel archeology, suppress diffs caused by CVS keyword expansion
Cc: "Git Mailing List" <git@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0707221205080.3607@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e4733910707221148g69d7600bk632abb7452ce9c7c@mail.gmail.com>
	 <alpine.LFD.0.999.0707221205080.3607@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/22/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Sun, 22 Jul 2007, Jon Smirl wrote:
> >
> > It would really be useful if git diff had an option for suppressing
> > diffs caused by CVS keyword expansion.
>
> I really think it's not a "git diff" issue, but it might be a "import"
> issue.
>
> IOW, I think you'd be a *lot* better off just not importing those things
> in the first place (which is what CVS does internally), or possibly
> importing them as two trees (ie you'd have the "non-log" version and the
> "log expansion" version, so that you can track and compare both).
>
> Doing the thing at "diff" time is certainly possible, but this is simply
> much better done as a totally independent preprocessing phase. The diff
> handling is already some of the more complex parts (and very central), it
> would be much simpler and efficient to not try to make that thing fancier,
> and instead solve the problem at the front-end.

These diffs are coming from companies doing GPL compliance without
really wanting to comply. CVS servers are not made available.


>
>                         Linus
>


-- 
Jon Smirl
jonsmirl@gmail.com
