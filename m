Return-Path: <linux-kernel-owner+w=401wt.eu-S965421AbXBLVhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965421AbXBLVhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 16:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965422AbXBLVhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 16:37:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965421AbXBLVhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 16:37:11 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alexey Dobriyan <adobriyan@openvz.org>
X-Fcc: ~/Mail/utrace
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: utrace regressions (was: -mm merge plans for 2.6.21)
In-Reply-To: Alexey Dobriyan's message of  Monday, 12 February 2007 15:51:56 +0300 <20070212125156.GA6035@localhost.sw.ru>
X-Windows: form follows malfunction.
Message-Id: <20070212213634.2777A1800E4@magilla.sf.frob.com>
Date: Mon, 12 Feb 2007 13:36:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> We're aware of two regressions compared to mainline if ptrace is utrace:

Thanks very much for bringing these to my attention.

> 1) zero holes for PTRACE_PEEKUSR vanished.

I've fixed this in the current patches.

> 2. The following proggie renders box unusable in ~10 seconds (but not
>    mainline kernel where Ctrl+C will kill process).

I haven't been able to reproduce this so far on my test machine.  I got
bored after about 10 minutes ("passed: 119200000").  The machine remains
responsive and the test dies immediately on hitting C-c.  I'll try it on
some other machines.  It would help to know what kind of unusable (crashy,
leaky, wedgey?).


Thanks,
Roland
