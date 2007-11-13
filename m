Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbXKMPww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbXKMPww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 10:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbXKMPwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 10:52:41 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:44099 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbXKMPwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 10:52:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qcmJLhRh8MRPQxXoqQ/siKINO/t5TPJo3rcyK+bSK2FafcPMsXDfvQS/cV/XZfUnt3t5PggG0mMFPx8KpUr05o6m7zK0e9ohc1edq3ITx51HJzY2wvfw30f/q/jZD8tBZSSvEOlOamI9gDFgjocaJYV5QAC0efXzuCcjetMU3e4=
Message-ID: <40f323d00711130752k19cab8eauc3456721274b3267@mail.gmail.com>
Date: Tue, 13 Nov 2007 16:52:32 +0100
From: "Benoit Boissinot" <bboissin@gmail.com>
To: "Mark Lord" <liml@rtr.ca>
Subject: Re: [BUG] New Kernel Bugs
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "David Miller" <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
In-Reply-To: <4739AFE0.20705@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org>
	 <20071113.033946.114918709.davem@davemloft.net>
	 <20071113034916.2556edd7.akpm@linux-foundation.org>
	 <20071113.035824.40509981.davem@davemloft.net>
	 <20071113041259.79c9a8c5.akpm@linux-foundation.org>
	 <20071113134029.GA30978@elte.hu> <4739AFE0.20705@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 13, 2007 3:08 PM, Mark Lord <liml@rtr.ca> wrote:
>
> Ingo Molnar wrote:
> ..
> > This is all QA-101 that _cannot be argued against on a rational basis_,
> > it's just that these sorts of things have been largely ignored for
> > years, in favor of the all-too-easy "open source means many eyeballs and
> > that is our QA" answer, which is a _good_ answer but by far not the most
> > intelligent answer! Today "many eyeballs" is simply not good enough and
> > nature (and other OS projects) will route us around if we dont change.
> ..
>
> QA-101 and "many eyeballs" are not at all in opposition.
> The latter is how we find out about bugs on uncommon hardware,
> and the former is what we need to track them and overall quality.
>
> A HUGE problem I have with current "efforts", is that once someone
> reports a bug, the onus seems to be 99% on the *reporter* to find
> the exact line of code or commit.  Ghad what a repressive method.
>

Btw, I used to test every -mm kernel. But since I've switched distros
(gentoo->ubuntu)
and I have less time, I feel it's harder to test -rc or -mm kernels (I
know this isn't a lkml problem
but more a distro problem, but I would love having an ubuntu blessed
repo with current dev kernel
for the latest stable ubuntu release).

For debugging, maybe it's time someone does an amazon ec2+s3 service
to automate the bisecting
and create .deb/.rpm from git, I don't know how much it would cost though.

regards,

Benoit
