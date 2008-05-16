Return-Path: <linux-kernel-owner+w=401wt.eu-S1760179AbYEPSq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179AbYEPSq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 14:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbYEPSqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 14:46:20 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:43301 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbYEPSqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 14:46:19 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: spontaneous reboots and hangs on x86_64
Date: Fri, 16 May 2008 20:46:16 +0200
User-Agent: KMail/1.9.7
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, "Adrian Bunk" <bunk@kernel.org>,
       kernel-testers@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <200805152201.49154.m.kozlowski@tuxland.pl> <200805160737.50373.m.kozlowski@tuxland.pl> <19f34abd0805160113i17eea98aub287f2d1be8f05d9@mail.gmail.com>
In-Reply-To: <19f34abd0805160113i17eea98aub287f2d1be8f05d9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805162046.16992.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> >> > > > ~/linux/linux-next $ git bisect start
> >> > > > fatal: ref HEAD is not a symbolic ref
> >> > > > Bad HEAD - I need a symbolic ref
> >> >
> >> > This would indicate something wrong with your clone of linux-next.  How
> >> > did you create the repository?
> >> >
> >> > > > - how does one bisect on linux-next?
> >> >
> >> > Any day's linux-next tree is a git tree like any other ...
> >>
> >> Hm it can be that I did something wrong ...
> >
> > and I did :/ I think I just started this repo in wrong way - according to linux-next FAQ.
> > I'll just start from scratch then.
> 
> You need to be on a branch. If git-branch says this:
> 
> $ git branch
> * (no branch)
> 
> then git will not allow you to bisect:
> 
> $ git bisect start v2.6.24 v2.6.25
> fatal: ref HEAD is not a symbolic ref
> Bad HEAD - I need a symbolic ref
> 
> Try first checkout out a new branch:
> 
> $ git checkout -b bisect
> Switched to a new branch "bisect"
> 
> $ git bisect start v2.6.24 v2.6.25
> Switched to branch "master"
> 
> Good luck!

Thanks, that was the case and your recipe works.

	Mariusz


