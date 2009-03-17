Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbZCQXkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbZCQXkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 19:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZCQXkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 19:40:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56042 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbZCQXki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 19:40:38 -0400
Date: Tue, 17 Mar 2009 23:40:18 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, travis@sgi.com
Subject: Re: [PULL] cpumask updates for arm
Message-ID: <20090317234018.GA20523@flint.arm.linux.org.uk>
References: <200903161444.09281.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903161444.09281.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 02:44:08PM +1030, Rusty Russell wrote:
> The following changes since commit 5bee17f18b595937e6beafeee5197868a3f74a06:
>   Kyle McMartin (1):
>         parisc: sba_iommu: fix build bug when CONFIG_PARISC_AGP=y
> 
> are available in the git repository at:
> 
>   ssh://master.kernel.org/home/ftp/pub/scm/linux/kernel/git/rusty/linux-2.6-cpumask-for-arm.git master

Is there any reason why you've based this tree on mine (with an alternates
file pointing at my tree?)  After all, the commit which this seems to be
based upon is one in Linus' tree.

It makes it impossible to pull via 

git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-cpumask-for-arm.git

$ git pull git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-cpumask-for-arm.git master
remote: error: object directory /home/rmk/linux-2.6-arm.git/objects does not exist; check .git/objects/info/alternates.
remote: Total 0 (delta 0), reused 0 (delta 0)
remote: aborting due to possible repository corruption on the remote side.
error: waitpid (async) failed
fatal: error in sideband demultiplexer

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
