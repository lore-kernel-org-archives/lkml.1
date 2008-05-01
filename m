Return-Path: <linux-kernel-owner+w=401wt.eu-S1761942AbYEAP32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761942AbYEAP32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 11:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760388AbYEAP3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 11:29:19 -0400
Received: from rv-out-0708.google.com ([209.85.198.243]:53428 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755305AbYEAP3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 11:29:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=eP2YqV+LlsbtMwF0kPGLVW+7tnkwUKvaDhaGxAqrQL/qLCCQtGfmhgFAwmuXLol/FxI5tJYPU/nCFeC0whCPx26HM3DCfABjXjobCmvJz7HfmGBIvNHEvGA7p9x8zmKz3qSTmE4SrQKjGL62B0fBz4QO5sGRDzKHtxX2nGifzis=
Message-ID: <2c0942db0805010829r50ea361ja9e62a33991dc640@mail.gmail.com>
Date: Thu, 1 May 2008 08:29:18 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: Re: Slow DOWN, please!!!
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Willy Tarreau" <w@1wt.eu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jiri Slaby" <jirislaby@gmail.com>
In-Reply-To: <200805011516.43159.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080429.190352.137408408.davem@davemloft.net>
	 <20080501055045.GC18597@1wt.eu> <200805011353.19335.rjw@sisk.pl>
	 <200805011516.43159.bzolnier@gmail.com>
X-Google-Sender-Auth: 3d849cbb017b2a15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2008 at 6:16 AM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
>
> On Thursday 01 May 2008, Rafael J. Wysocki wrote:
>  > How about:
>  >
>  > (1) Merge a couple of trees at a time (one tree at a time would be ideal, but
>  >     that's impossible due to the total number of trees).
>  > (2) After (1) give testers some time to report problems introduced by the
>  >     merge.
>  > (3) Wait until the most urgent problems are resolved.  Revert the offending
>  >     changes if there's no solution within given time.
>  > (4) Repeat for another couple of trees.
>  > (5) Arrange things so that every tree gets merged once every two months.
>  >
>  > This would also give us an idea of which trees introduce more problems.
>
>  ...and what would you do with such information?
[...]
>  Same goes for any other kind of improvement by incorporating "punishment" as
>  the part of the process.

When a teacher assigns grades in a class, it's not punishment, it's feedback.

I don't think anyone *intends* to push crap into the tree. However,
with the barrier to getting things into the tree so low, some may feel
there's less incentive to try to get things right the first (or
second) time. It would be nice to provide that incentive.

Normally, it'd be peer-review of the uncommitted patches. We don't
have a lot of that going on here, though. So,
peer-review-after-the-fact, ie, who placed this massive turd in the
tree, and everyone swivels an eye over there and asks what went wrong,
and how do we prevent it in the future. Those conversations seem to be
happening already, time to time.

And as a policy suggestion, if we're past rc1 and someone has
identified a commit as the root of a regression/bug, then the policy
should be just to revert it immediately, no questions asked. Let the
original author work with the person who identified the problem and
resend a fixed commit later. We lose testers in the meantime, and
perhaps the extra effort involved in having the author work out the
issues and redo the patch will help prevent drive-by patching in the
future.
