Return-Path: <linux-kernel-owner+w=401wt.eu-S1760838AbXGSCcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760838AbXGSCcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 22:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbXGSCcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 22:32:15 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34984 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbXGSCcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 22:32:14 -0400
Message-ID: <469ECD29.2010909@garzik.org>
Date: Wed, 18 Jul 2007 22:32:09 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ak@suse.de, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net, benh@kernel.crashing.org
Subject: Re: [git patches] two warning fixes
References: <20070718235504.GA9601@havoc.gtf.org> <alpine.LFD.0.999.0707181834070.27353@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707181834070.27353@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> So let's make a new rule:
> 
>   We absolutely NEVER add things like "must_check" unless not checking 
>   causes a real and obvious SECURITY ISSUE.
> 
>   And we absolutely *never* add crap like "deprecated", where the only 
>   point of the warning is to effectively hide *real* problems.
> 
> So realistically, the only thing that needs must_check is pretty much 
> things like "get_user()" and quite frankly, I'm not sure even about that 
> one.
> 
> Ok?


Sounds great to me...  My overall goal is killing useless warnings that 
continually obscure real ones.

	Jeff


