Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbXI0NvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbXI0NvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 09:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbXI0NvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 09:51:03 -0400
Received: from twin.jikos.cz ([213.151.79.26]:36459 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254AbXI0NvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 09:51:01 -0400
Date: Thu, 27 Sep 2007 15:49:05 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Miloslav Semler <majkls@prepere.com>
cc: Kyle Moffett <mrmacman_g4@mac.com>, David Newall <david@davidnewall.com>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Serge E. Hallyn" <serge@hallyn.com>, Bill Davidsen <davidsen@tmr.com>,
       Philipp Marek <philipp@marek.priv.at>, 7eggert@gmx.de, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Subject: Re: Chroot bug
In-Reply-To: <46FA7450.5020707@prepere.com>
Message-ID: <Pine.LNX.4.64.0709271548020.22331@twin.jikos.cz>
References: <46F83474.5040503@davidnewall.com> <20070924230008.GA3160@vino.hallyn.com>
 <46F8BC8A.7080006@davidnewall.com> <20070925114947.GA9721@vino.hallyn.com>
 <46F91417.9050600@davidnewall.com> <46F924E3.50205@davidnewall.com>
 <20070925163040.12a3c2f8@the-village.bc.nu> <46F92AAB.1060903@davidnewall.com>
 <20070925164806.4cadc6a5@the-village.bc.nu> <46F99EDE.70905@davidnewall.com>
 <20070926005551.GS6800@stusta.de> <F23AFB4D-E989-4F06-A256-4D12D852DFA2@mac.com>
 <46FA341A.80706@davidnewall.com> <6BA6E9EE-B67B-4334-AC83-9B8E30527832@mac.com>
 <46FA5A85.20407@prepere.com> <73A0FA2C-7202-4E5C-9521-C2BC7026DE3B@mac.com>
 <46FA7450.5020707@prepere.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007, Miloslav Semler wrote:

> so there is no discussion about mount & others. I think, if you have 
> CAP_SYS_MOUNT/CAP_SYS_ADMIN, you need not solve chroot() and how to 
> break it.

CAP_SYS_PTRACE allows you to break out of chroot in a pretty trivial way 
too.

-- 
Jiri Kosina
