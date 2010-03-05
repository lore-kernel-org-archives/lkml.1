Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab0CEPGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 10:06:51 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47903 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751771Ab0CEPGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 10:06:48 -0500
Date: Fri, 5 Mar 2010 15:09:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, skeggsb@gmail.com, torvalds@linux-foundation.org,
       airlied@gmail.com, airlied@linux.ie, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
Message-ID: <20100305150934.0c0f83ef@lxorguk.ukuu.org.uk>
In-Reply-To: <20100305.063718.211238119.davem@davemloft.net>
References: <1267748927.3496.6.camel@nisroch>
	<20100305064955.GA6453@elte.hu>
	<20100305123834.0d9c6277@lxorguk.ukuu.org.uk>
	<20100305.063718.211238119.davem@davemloft.net>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If it effects such a large number of people, which this noveau thing
> does, it's entirely relevant to everyone.  And the way it's breaking
> and making kernel development difficult for so many people matters to
> us.
> 
> It's about the tester base, and this breakage shrinks the tester base
> considerably.
> 
> Or do you want the kernel tested by less people?

I think you miss a bigger picture ?

If Fedora hadn't merged it then it wouldn't have gotten to the state of
usability it had. If Fedora hadn't merged it then several hundred
thousand users wouldn't have had useful working machines.

So - do you want Linux used by a lot less people, and to have no Nvidia
driver ?

See - its all about viewpoints. Do you think screaming at people who did
no wrong increases the kernel developer and testing base ? No I thought
not.

To be honest the big thing I object to here is certain people who
should know better behaving like small children. Not just in the sense of
throwing their toys around because mummy didn't buy them the right
sweetie but in not thinking about how other people see the problem and
their actions.

- Fedora merged the stuff to make it work and to improve life for lots of
  users. Good intent, rational logical behaviour

- Linus asked for it to be merged and was warned about the ABI. He did
  that for good, sound reasons.

- The developers accepted the merge to staging so they could fix the ABI
  later, they made that clear - again all good sound intentions

- The ABI change and clean up was done - again good sound intentions,
  rational behaviour

- Linus then threw a tantrum. He's right there are issues about how user
  migration should be handled but he didn't need to go screaming at the
  DRM people (not their fault), Fedora (who had good sensible goals in
  what they did) or the Nouveau people (who told him what was going on
  well in advance and did exactly what was asked of them before)

Firstly he's being hypocritical (he keeps saying he doesn't want to
control distributions, he even refused to allow ext2 to be merged *until*
Red Hat shipped it), he was told clearly, and staging is for unfixed ABIs.
Secondly he's shouting at people who all did a right thing, which only
produces bad feelings.

All that was needed was a

"Hey guys, I know its in staging but this is going to be a problem, can
 we either fix back compatibility or have some kind of migration policy
 and the tools so I can test it - otherwise I can't merge this"

No blaming, no tantrums, no judgemental comments from a single viewpoint.
A collection of good intentions produced a problem. It happens all the
time, screaming and blaming may be how politicians sometimes behave but we
can surely do better ?

Alan
