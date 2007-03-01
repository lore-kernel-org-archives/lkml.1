Return-Path: <linux-kernel-owner+w=401wt.eu-S1030317AbXCAVij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030317AbXCAVij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 16:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030329AbXCAVij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 16:38:39 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:47402 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030317AbXCAVii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 16:38:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=JnDvO8bh7j7/Woq2fyegakEGFVKTefbKP8c+hjMiROYVIVSqTZ0Oha5yzH3Z1wbmHk57Sc/KcEoJkJ2a890Iaqz7QKwKJYDDgYsVnX/Nc8QtW8uSo5V7krAG6qEkXsxJK0FCfqszxlVhmQWCX27gOj6hi4DhwZw1MXZCvTYpvQw=
Message-ID: <953c67830703011338n6c9c6b8wafe68b6af6b974b1@mail.gmail.com>
Date: Thu, 1 Mar 2007 13:38:36 -0800
From: "Thomas Davies" <daviesth@onid.orst.edu>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH] fix warnings that occur on make *docs
Cc: kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070301104938.8674ca7b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <953c67830703011039x53a28509v3af6dddabffbca9f@mail.gmail.com>
	 <20070301104938.8674ca7b.randy.dunlap@oracle.com>
X-Google-Sender-Auth: 635c08fe33e97ad1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/1/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Thu, 1 Mar 2007 10:39:41 -0800 Thomas Davies wrote:
>
> > From: Thomas Davies <daviesth@onid.orst.edu>
> >
> > Cleaned up comments and whitespace in /drivers/message/fusion/*.c and also
> > /lib/bitmap.c to remove make *docs warnings.  An attempt by a newbie
> > to contribute
> > in some small way to the codebase.  Did I do it right?
>
> Hi,
>
> Your patch looks fine (until I tested it), but I have already
> corrected these warnings.  The patches have been in the -mm patchset
> for awhile and Andrew has sent some of it to Linus to be merged.
> Other parts need to go thru other maintainers.

Thank you for the feedback Randy.  Looks like I missed a step in the cycle;
I cloned Linus' tree with git from
git://git.kernel.org/pub/[...]/torvalds/linux-2.6.git,
was this wrong?  Is there another tree I should be cloning, or do I
apply the -mm
patch from kernel.org before making this sort of change? (The latter I suspect.)

> > Signed-off-by: Thomas Davies <daviesth@onid.orst.edu>
> > ---
> > diff -uprN -X linux-2.6/Documentation/dontdiff
> > linux-2.6/drivers/message/fusion/mptbase.c
> > linux-2.6-new/drivers/message/fusion/mptbase.c
>
> Looks like your mail client split these lines (above and below)
> so that 'patch' cannot apply the patch.
> lkml.org shows the same splitting, so I guess it's not my
> mail client on the reading end that is doing this.

I thought I could get away with using gmail in plain text mode, guess
I'll go back to using mutt.

-Tom

> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
>
