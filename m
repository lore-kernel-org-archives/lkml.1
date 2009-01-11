Return-Path: <linux-kernel-owner+w=401wt.eu-S1755761AbZAKAiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761AbZAKAiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 19:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbZAKAiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 19:38:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52624 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbZAKAiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 19:38:10 -0500
Message-ID: <49693E70.4050303@zytor.com>
Date: Sat, 10 Jan 2009 16:33:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alain Knaff <alain@knaff.lu>
CC: Sam Ravnborg <sam@ravnborg.org>, Russell King <rmk@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] bzip2/lzma kernel compression
References: <200901091845.n09IjBsT003630@terminus.zytor.com> <4968A737.7040909@knaff.lu>
In-Reply-To: <4968A737.7040909@knaff.lu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alain Knaff wrote:
> 
> But now I am curious how this will evolve from here. I suppose it will
> soon appear in one of the patch-2.6.28-gitxy.gz under
> ftp://ftp.kernel.org/pub/linux/kernel/v2.6/snapshots , and then in an
> 2.6.29-rcx etc.
> Or are there some more other steps involved in between?
> 

Well, Linus opted not to merge it for 2.6.29-rc1, which means it is dead
for this merge cycle.  This gives us a couple of options, with the aim
to get it merged into 2.6.30:

- We can continue to carry it in the -tip tree, which also means it will
  be in the linux-next tree.
- We can push it to Andrew Morton for the -mm tree.
- Sam could take it in his kbuild tree.

Out of these, I think the kbuild tree is entirely inappropriate.  The
selection of the other two is mostly a matter of testing, and which way
will be easier to add the ARM code and other arch support.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

