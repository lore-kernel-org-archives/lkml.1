Return-Path: <linux-kernel-owner+w=401wt.eu-S935850AbXGRXPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935850AbXGRXPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759419AbXGRXO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:14:59 -0400
Received: from smtp151.iad.emailsrvr.com ([207.97.245.151]:55751 "EHLO
	smtp151.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195AbXGRXO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:14:59 -0400
Message-ID: <469E9E98.4000003@gentoo.org>
Date: Wed, 18 Jul 2007 19:13:28 -0400
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070618)
MIME-Version: 1.0
To: Steve French <smfrench@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: -mm breaks and merging maintainer git trees with mainline
References: <524f69650707181309w42d665c9ua49179b9d7e0a6b1@mail.gmail.com>
In-Reply-To: <524f69650707181309w42d665c9ua49179b9d7e0a6b1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steve French wrote:
> What is the currently recommended procedure for merging a maintainer
> tree with mainline in order to reorder all of the fixes in the
> maintainer tree, after the changes in the linux-2.6. tree (to make the
> eventual merge from Linus easier)?
> 
> In this particular case, the
> http://git.kernel.org/?p=linux/kernel/git/sfrench/cifs-2.6.git tree
> has a few dozen changesets that are not in its parent yet (and the
> cifs-2.6.git is at 2.6.22-rc5 level)
> (http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git) but
> mainline now has fixes which affect the same directory as the
> maintainer tree maintains.

I think you can do:

git checkout origin
git pull
git checkout master
git rebase origin

In general, people seem to keep "from-linus" branches which they never 
modify. I guess they only ever pull linus into there, and then rebase 
their customised branch-of-choice (master, in your case) on top of that 
one in order to keep up-to-date.

Daniel
