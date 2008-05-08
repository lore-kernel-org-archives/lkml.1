Return-Path: <linux-kernel-owner+w=401wt.eu-S934146AbYEHWTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934146AbYEHWTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 18:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762494AbYEHWTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 18:19:00 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:56036 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762183AbYEHWS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 18:18:59 -0400
Message-ID: <48237CA0.4080001@keyaccess.nl>
Date: Fri, 09 May 2008 00:20:16 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
Subject: GIT bisection range errors
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good day.

I'm in a git bisect and am experiencing strangeness. I did a

$ git checkout -b rc v2.6.26-rc1
$ git bisect start
$ git bisect bad
$ git bisect good v2.6.25

Yet, during this I'm finding myself at 2.6.25-rc6 and 2.6.25-rc8
as the last two results (both good...).

Here's the BISECT_LOG upto this point. Is there anyone available
who understands this well enough to be able to say from this that
my tree is fubar? It should be a straight Linus' clone, and it's
always pulling without trouble.

git-bisect start
# bad: [2ddcca36c8bcfa251724fe342c8327451988be0d] Linux 2.6.26-rc1
git-bisect bad 2ddcca36c8bcfa251724fe342c8327451988be0d
# good: [4b119e21d0c66c22e8ca03df05d9de623d0eb50f] Linux 2.6.25
git-bisect good 4b119e21d0c66c22e8ca03df05d9de623d0eb50f
# bad: [7ae44cfa7ab29b277691327e8de790d7b880722f] [ALSA] snd-powermac: style awacs.s and awacs.h
git-bisect bad 7ae44cfa7ab29b277691327e8de790d7b880722f
# good: [7cea51be4e91edad05bd834f3235b45c57783f0d] security: fix up documentation for security_module_enable
git-bisect good 7cea51be4e91edad05bd834f3235b45c57783f0d
# bad: [8f19ca1341a6d89bd96e2e69e6e10f46d3258089] x86: unify gfp masks
git-bisect bad 8f19ca1341a6d89bd96e2e69e6e10f46d3258089
# good: [f49e1aa133c2c9b74b5dfddca8863609bbda9086] [NETFILTER]: nf_conntrack_sip: update copyright
git-bisect good f49e1aa133c2c9b74b5dfddca8863609bbda9086
# good: [0b18542b7f5379e052d2a3132be91185776e7ceb] [NET]: Sink IPv6 menuoptions into its own submenu
git-bisect good 0b18542b7f5379e052d2a3132be91185776e7ceb


Rene.
