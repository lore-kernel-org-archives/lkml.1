Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbZA0TDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbZA0TDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 14:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbZA0TDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 14:03:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755056AbZA0TDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 14:03:31 -0500
Date: Tue, 27 Jan 2009 11:02:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Garzik <jeff@garzik.org>
cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
In-Reply-To: <497F545B.6000104@garzik.org>
Message-ID: <alpine.LFD.2.00.0901271100320.3123@localhost.localdomain>
References: <20090127073055.GA30360@havoc.gtf.org> <alpine.LFD.2.00.0901270748290.3123@localhost.localdomain> <497F545B.6000104@garzik.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 Jan 2009, Jeff Garzik wrote:
> 
> I also habitually _avoid_ "git commit -a", so I am surprised that I actually
> made this mistake.  I am 100% certain that I issued neither "git rm" nor "git
> update-index" commands on that file.
>
> Granted, I should have been more careful, but I am also surprised this
> happened at all.

Well, it's attributed to Tejun, and he probably sent you a "git diff". The 
delete part of such a diff is pretty small, so you both probably missed 
it at the top of the diff:

	diff --git a/arch/arm/mach-integrator/clock.h b/arch/arm/mach-integrator/clock.h
	deleted file mode 100644
	index e69de29..0000000

and then you used "git am -s" or something to apply it and delete that 
file.

No "git commit -a" necessary - just a simple "git diff" after having done 
a "make distclean" and then sending the result off by email without 
looking any closer..

			Linus
