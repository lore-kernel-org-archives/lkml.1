Return-Path: <linux-kernel-owner+w=401wt.eu-S1764479AbXGPXgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764479AbXGPXgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbXGPXf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:35:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:18654 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbXGPXfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:35:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iAGpjlgqVhxrayc3kBDXS5uD0icwJAlKolpwy+IRC0cPIpb3ygo9qD929A7y4hRLV+and7bDTn6YQ2bJEzbwe+AeqasbgwFsyhkViBhBGwA6r8d8Bg7xsVV7tCiZs+Tx93oCUU5k17otClCpkR1jK/9bOLa93a7sw2gtn0IGlPE=
Message-ID: <9a8748490707161635l317aa778t6af2b8e68cc08f84@mail.gmail.com>
Date: Tue, 17 Jul 2007 01:35:54 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Cc: "Ray Lee" <ray-lk@madrabbit.org>, "Bodo Eggert" <7eggert@gmx.de>,
       "Matt Mackall" <mpm@selenic.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "David Chinner" <dgc@sgi.com>, "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <469BFDA7.1040204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8FO1e-2jW-35@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it>
	 <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com>
	 <Pine.LNX.4.58.0707161523500.25779@be1.lrz>
	 <469BF104.1040703@gmail.com>
	 <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>
	 <469BF768.6040200@gmail.com>
	 <2c0942db0707161613lff9c07bpcf002b9139163a86@mail.gmail.com>
	 <469BFDA7.1040204@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/07, Rene Herman <rene.herman@gmail.com> wrote:
> On 07/17/2007 01:13 AM, Ray Lee wrote:
>
> > Given that there's actual, y'know, reports of people who can easily
> > crash a 4k+interrupt stacks kernel, and not an 8k one, I think the
> > current evidence speaks for itself.
>
> Where?
>
> > The point remains that the burden of proof of the safety of the 4k only
> > option is upon those people who want to remove the 8k option.
>
> Removing any such option was not the objective of this thread, just lifting
> 4K stacks from debug and making it the default. People fortunate enough to
> use workloads where some piece of crap code by accident works more often
> with the current shared 8K stacks then it does with the unshared 4K stacks
> can then still nicely not select it (or fix the code if possible).
>
I may have worded the initial email a bit too heavily towards 8K
removal, but that was mainly to provoke some discussion.  Nothing
should get removed without a fair (and long) warning in
feature-removal-schedule.txt and ofcourse not before we know that the
new option is at least as safe as what we intend to remove, so the
patch really was just intended as a fairly harmless nudge towards
getting 4K stacks into a shape where we can eventually start
considering 8K removal.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
