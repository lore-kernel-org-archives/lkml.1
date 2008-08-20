Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbYHTWvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbYHTWvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 18:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbYHTWvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 18:51:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752062AbYHTWvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 18:51:40 -0400
Date: Wed, 20 Aug 2008 15:51:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [OT] 'git pull' from Linus' tree doesn't work for me any more
In-Reply-To: <200808210045.42693.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.10.0808201548300.3487@nehalem.linux-foundation.org>
References: <200808210045.42693.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Aug 2008, Rafael J. Wysocki wrote:
> 
> Does anybody else see something like this after the latest push from Linus:
> 
> ~/devel/linux-2.6> git pull
> fatal: The remote end hung up unexpectedly
> Cannot get the repository state from git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> 
> I see this on two different machines.

It might easily be just a temporary glitch in the matrix.

It happens sometimes because the kernel.org machines use rsync to 
synchronize with each other, and since it's not really a git-aware 
protocol, rsync might copy the branch files _before_ it copies the object 
files.

It starts working after a few minutes when the rsync has completed.

		Linus
