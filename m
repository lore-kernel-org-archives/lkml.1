Return-Path: <linux-kernel-owner+w=401wt.eu-S1759650AbXHBRD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759650AbXHBRD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 13:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759493AbXHBRDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 13:03:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:61621 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759480AbXHBRDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 13:03:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p+voj1G/Zkso5LauuNnRyQ0SBpmt318I5/8LPLqefrYkn3n2sLK+wkxfwW0ALJnRCrmNEVrdZ7cmCcBPj6UBLbyPp6JpRC5BfdW6ZZqJSapEJORE8eglNlhEnrJLnS3gsjNNNEsPTlEgoB8eLhk8YnMpO8oi7Lo193nLDnUhtl8=
Message-ID: <dda83e780708021003k7ada3fb5v97a067788e967ed6@mail.gmail.com>
Date: Thu, 2 Aug 2007 10:03:36 -0700
From: "Bret Towe" <magnade@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: Is PIE randomization breaking klibc binaries?
Cc: "Ulrich Kunitz" <kune@deine-taler.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Chuck Ebbert" <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       "Jan Kratochvil" <honza@jikos.cz>, jakub@redhat.com
In-Reply-To: <Pine.LNX.4.64.0708021316020.1779@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46A667BD.5080106@redhat.com> <46A68118.9080902@zytor.com>
	 <20070725063243.GA25148@deine-taler.de>
	 <Pine.LNX.4.64.0707311326090.26532@jikos.suse.cz>
	 <46AF24B2.8070900@zytor.com>
	 <Pine.LNX.4.64.0707311418040.26532@jikos.suse.cz>
	 <46AF27E6.5080008@zytor.com>
	 <Pine.LNX.4.64.0708011604570.6311@jikos.suse.cz>
	 <20070802042942.GA4054@deine-taler.de>
	 <Pine.LNX.4.64.0708021316020.1779@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/2/07, Jiri Kosina <jkosina@suse.cz> wrote:
> On Thu, 2 Aug 2007, Ulrich Kunitz wrote:
>
> > Here is the .config file. I used it directly with 60bfba7e8 and could
> > reproduce the bug. (All other builds after the patch could also
> > reproduce the bug.)
>
> Thanks, I used your .config against 60bfba7e8 on x86_64, and still can't
> seem to be able to reproduce the problem:
>
> linux-w027:~ # echo "test" | ./klibc-1.5/usr/utils/shared/cat
> test
> linux-w027:~ # echo "test" | ./klibc-1.5/usr/utils/static/cat
> test
>
> hpa, were you successful reproducing this?
>
> Bret, I can see that you also reported some related segfaults, what were
> your conditions that triggered it please?

not really much to it just did the usual make oldconfig on a current
git and installed
it with ubuntus kernel tools and it was broken
the system is a 64bit feisty setup nothing special to me at least
i can attach the .config later (not near the computer and its not on atm)

> --
> Jiri Kosina
> SUSE Labs
>
