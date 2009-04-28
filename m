Return-Path: <linux-kernel-owner+w=401wt.eu-S1759209AbZD1CCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209AbZD1CCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 22:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757096AbZD1CCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 22:02:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756595AbZD1CCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 22:02:38 -0400
Date: Mon, 27 Apr 2009 18:59:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Tejun Heo <tj@kernel.org>
cc: Dave Airlie <airlied@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kms in defconfig
In-Reply-To: <49F65FA2.4010603@kernel.org>
Message-ID: <alpine.LFD.2.00.0904271852510.22156@localhost.localdomain>
References: <21d7e9970904270121s1c58365bqc8933f8a3ffc5f1a@mail.gmail.com>  <20090427083935.GA20941@elte.hu> <21d7e9970904270156v54a6483fs20d5b31c97a1d482@mail.gmail.com> <49F65FA2.4010603@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 28 Apr 2009, Tejun Heo wrote:
> 
> I think defconfig should enable options such that it shows where
> upstream kernel is headed, so FWIW +1 for KMS from me.

I'd actually love to get rid of the stupid defconfig's entirely. They've 
lost pretty much all relevance over the years, except for specific cases 
where you might have defconfigs that are for specific platforms.

IOW, the embedded kind of "per-platform defconfig" at lest is a useful 
starting point. But even there I'm not 100% sure that it makes sense to 
pollute the kernel source tree with them - they mess up things like

	git grep PREVENT_FIRMWARE_BUILD

horribly.

IOW, they're likely to be more pain than they are worth. And they really 
aren't useful starting points for normal people (who are probably better 
off starting with their distro kernel config) or likely even for most 
kernel developers (who hopefully have noticed that they can install a 
per-machine defconfig in /etc/kernel-config and forget about it).

I'd love to just delete them all.

			Linus
