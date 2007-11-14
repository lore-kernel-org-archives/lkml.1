Return-Path: <linux-kernel-owner+w=401wt.eu-S1761146AbXKNAel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761146AbXKNAel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 19:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763048AbXKNAeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 19:34:22 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:28683 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762533AbXKNAeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 19:34:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=LYoqwBEUd9yZ0rvGwdP42oA6zH5E68YhtmYlFtG/xdV/SQUF+pOzG36Xi1oADzkRyNWdKsInATGuRjTzH3ZEu3Ue51p/OgI/JhW1HAH7nJ1P6jlnolc2wm5IjMqn5zb49XVh36c3Qb+/lnzGcc6mNhPTLTuS9axse2KxvTJkuhk=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Mark Lord <liml@rtr.ca>
Subject: Re: [BUG] New Kernel Bugs
Date: Tue, 13 Nov 2007 17:34:11 -0700
User-Agent: KMail/1.9.1
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org> <20071113134029.GA30978@elte.hu> <4739AFE0.20705@rtr.ca>
In-Reply-To: <4739AFE0.20705@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711131734.11353.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2007 07:08, Mark Lord wrote:
> Ingo Molnar wrote:
> ..
>
> > This is all QA-101 that _cannot be argued against on a rational basis_,
> > it's just that these sorts of things have been largely ignored for
> > years, in favor of the all-too-easy "open source means many eyeballs and
> > that is our QA" answer, which is a _good_ answer but by far not the most
> > intelligent answer! Today "many eyeballs" is simply not good enough and
> > nature (and other OS projects) will route us around if we dont change.
>
> ..
>
> QA-101 and "many eyeballs" are not at all in opposition.
> The latter is how we find out about bugs on uncommon hardware,
> and the former is what we need to track them and overall quality.
>
> A HUGE problem I have with current "efforts", is that once someone
> reports a bug, the onus seems to be 99% on the *reporter* to find
> the exact line of code or commit.  Ghad what a repressive method.

This is the only method that scales.

Developer has only 24 hours in each day, and sometimes he needs to eat,
sleep, and maybe even pay attention to e.g. his kids.

But bug reporters are much more numerous and they have more
hours in one day combined.

BUT - it means that developers should try to increase user base,
not scare users away.

> And if the "developer" who broke the damn thing, or who at least
> "claims" to be supporting that code, cannot "reproduce" the bug,
> they drop it completely.

Developer should let reporter know that reporter needs to help
a bit here. Sometimes a bit of hand holding is needed, but it
pays off because you breed more qualified testers/bug reporters.

> Contrast that flawed approach with how Linus does things..
> he thinks through the symptoms, matches them to the code,
> and figures out what the few possibilities might be,
> and feeds back some trial balloon patches for the bug reporter to try.
>
> MUCH better.
>
> And remember, *I'm* an old-time Linux kernel developer.. just think about
> the people reporting bugs who haven't been around here since 1992..

Yes. Developers should not grow more and more unhelpful
and arrogant towards their users just because inexperienced
users send incomplete/poorly written bug reports.
They need to provide help, not humiliate/ignore.

I think we agree here.
--
vda
