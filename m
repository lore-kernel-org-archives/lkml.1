Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbZJFRKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbZJFRKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757942AbZJFRKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:10:14 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:57977 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755092AbZJFRKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:10:13 -0400
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.32-rc3
Date: Tue, 6 Oct 2009 19:09:34 +0200
User-Agent: KMail/1.9.9
Cc: mingo@elte.hu, hohndel@infradead.org, linux-kernel@vger.kernel.org
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <alpine.LFD.2.01.0910060828530.3432@localhost.localdomain>
In-reply-To: <alpine.LFD.2.01.0910060828530.3432@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910061909.35878.elendil@planet.nl>
X-OriginalArrivalTime: 06 Oct 2009 17:09:36.0339 (UTC) FILETIME=[C80F0230:01CA46A7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> And what people are suggesting with a 2.6.32-rc0 would just lead to
> people now rebasing their work NOT EVEN ON A RELEASE. They'd want to
> rebase it on top of that made-up commit (2.6.32-rc0), so now from a
> development standpoint that commit suddenly becomes more important than
> the release itself.

IMO you're looking at this from the wrong side: the developer PoV. The 
request is made from a *user* PoV.
Users very simply want to avoid that they accidentally install a merge 
window kernel over their stable kernel. IMO that makes sense.

Developers are supposed to be able to take care of themselves; the mainline 
tree should aim to make things easy for users.

I see the release versions purely as reference points. And -rc0 is 
obviously useless from that perspective, which is why it should be just a 
Makefile thing and not a tag. But -rc0 is IMO very useful to distinguish 
what kernels someone has installed.

BTW, including the commit number in the version string has a major 
disadvantage: kernels will get installed *alongside* eachother instead of 
the newer kernel replacing the older one. Result is that /boot partitions 
fill up much more quickly.

Cheers,
FJP
