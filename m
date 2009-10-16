Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbZJPFuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbZJPFuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 01:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbZJPFuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 01:50:19 -0400
Received: from bgo1smout1.broadpark.no ([217.13.4.94]:55960 "EHLO
	bgo1smout1.broadpark.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbZJPFuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 01:50:18 -0400
X-Greylist: delayed 3641 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Oct 2009 01:50:18 EDT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
From: Kjetil Barvik <barvik@broadpark.no>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc5
Organization: private
References: <alpine.LFD.2.01.0910151756550.4017@localhost.localdomain>
Date: Fri, 16 Oct 2009 06:48:13 +0200
In-reply-to: <alpine.LFD.2.01.0910151756550.4017@localhost.localdomain>
Message-id: <86aazsx7ua.fsf@broadpark.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> 90% of the bulk of the changes since -rc4 are in drivers, with most of 
> it coming from two new network drivers (stmmac and vmxnet3). But apart 
> from the new drivers, there's almost 300 commits in there, 

  some more statistics(1):

        243 "real" commits
      +  46 merge-commits (34 by Linus)
      = 289 total commits (almost 300)

  -- kjetil

  1) from the following git commands (git version 1.6.4.4)
        git log --oneline -M v2.6.32-rc4..v2.6.32-rc5 | wc -l
        git log --no-merges --oneline -M v2.6.32-rc4..v2.6.32-rc5 | wc -l
        git log --merges --oneline -M v2.6.32-rc4..v2.6.32-rc5 | wc -l
        git log --merges --author="Linus Torvalds" --oneline -M v2.6.32-rc4..v2.6.32-rc5 | wc -l
