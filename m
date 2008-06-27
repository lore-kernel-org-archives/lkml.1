Return-Path: <linux-kernel-owner+w=401wt.eu-S1761453AbYF0Tme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761453AbYF0Tme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 15:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757857AbYF0TmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 15:42:23 -0400
Received: from [194.117.236.238] ([194.117.236.238]:60793 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757683AbYF0TmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 15:42:22 -0400
Date: Fri, 27 Jun 2008 22:41:15 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hannes@saeurebad.de, tzanussi@gmail.com, penberg@cs.helsinki.fi,
       torvalds@linux-foundation.org, compudj@krystal.dyndns.org,
       vegard.nossum@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Full conversion to early_initcall() interface,
 remove old interface.
Message-ID: <20080627224115.7f76b11e@linux360.ro>
In-Reply-To: <20080627114515.65b00a9e.akpm@linux-foundation.org>
References: <20080623153056.1862c14e@linux360.ro>
	<20080623172742.be332a53.akpm@linux-foundation.org>
	<20080625120151.56180b47@linux360.ro>
	<87d4m3ywpu.fsf@skyscraper.fehenstaub.lan>
	<20080627142800.2c0b5cf1@linux360.ro>
	<20080627114515.65b00a9e.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008 11:45:15 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> It is a bit of a pain.  I avoid asking people to raise patches against
> -mm unless it's really necessary.

Just my 2 cents... you said in a 2006 discussion that you don't use Git
because you modify and drop patches often. I'd like to point out that
newer Git releases support interactive rebasing, which can do very nice
things:
- reorder commits (also adds '<<<', '===', '>>>' merge-like stuff when
that fails, so you can fix it easier)
- squash a commit into the previous -> solves the "patch that fixes
another patch" problem.
- edit commits different than HEAD
That is all doable with 'git-rebase -i'.

But maybe you got used to quilt and changing requires more effort at
the beginning, so I'm not going to argue too much.

I hope this helps.


	Cheers,
	Eduard
