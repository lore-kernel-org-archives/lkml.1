Return-Path: <linux-kernel-owner+w=401wt.eu-S935187AbZJOVCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935187AbZJOVCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 17:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763034AbZJOVCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 17:02:32 -0400
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:63925 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763031AbZJOVCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 17:02:31 -0400
From: Frans Pop <elendil@planet.nl>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic
Date: Thu, 15 Oct 2009 23:01:53 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <200910151613.10334.elendil@planet.nl> <alpine.DEB.1.00.0910151324481.17578@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.0910151324481.17578@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910152301.54826.elendil@planet.nl>
X-OriginalArrivalTime: 15 Oct 2009 21:01:54.0499 (UTC) FILETIME=[B9913130:01CA4DDA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 October 2009, David Rientjes wrote:
> Sigh, this is becoming ridiculous.

Yes, I thoroughly agree. I'm afraid I don't see much point in repeating my 
arguments anymore.

We seem to be unable to get eachothers arguments. I think I understand your 
PoV, or at least your aims, and I even agree with those. I don't think you 
really get my concerns about the implementation, but I give up. I seem 
unable to make you understand; probably my limitation. So, let's just 
agree to disagree.

My conclusion in the mean time is that the whole concept of having the "+" 
is broken. Especially since my discovery earlier today [1] that it is more 
than likely to break existing scripts in userspace (not packaging, but 
regular userspace).

I plan to continue to use my own naming conventions, even if that means I 
have to patch the "+' out of the Makefile. Especially since it seems I 
have to decide between risking breakage in user space and confirming to 
this new standard. And that choice is simple.

> Do you really expect people to email bug reports and say "btw, I
> compiled with KBUILD_NO_LOCALVERSION_EXTRA because I thought it looked
> prettier, this is actually Linus' git at a3ccf63"?

In the current situation I already frequently provide the output of 'git 
describe master' as part of bug reports. Nothing new there. And users will 
*still* need to do that as the "+" does not tell anyone where exactly they 
are at. It could equally be release +50 or +4000 commits.

Cheers.
FJP

[1] http://lkml.org/lkml/2009/10/15/210
