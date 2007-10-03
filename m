Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbXJCObS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbXJCObS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 10:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbXJCObF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 10:31:05 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:51834 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbXJCObE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 10:31:04 -0400
Date: Wed, 03 Oct 2007 23:32:49 +0900 (JST)
Message-Id: <20071003.233249.126777093.yoshfuji@linux-ipv6.org>
To: penguin-kernel@I-love.SAKURA.ne.jp
Cc: a.p.zijlstra@chello.nl, kaigai@kaigai.gr.jp, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org, yoshfuji@linux-ipv6.org
Subject: Re: [TOMOYO 05/15](repost) Domain transition handler functions.
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <200710032326.FJF32915.OQOOHLMtFSFJFV@I-love.SAKURA.ne.jp>
References: <200710032259.HJF90663.OFMLOJtQHOFVSF@I-love.SAKURA.ne.jp>
	<1191420442.5599.12.camel@lappy>
	<200710032326.FJF32915.OQOOHLMtFSFJFV@I-love.SAKURA.ne.jp>
Organization: USAGI/WIDE Project
X-URL: http://www.yoshifuji.org/%7Ehideaki/
X-Fingerprint: 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
X-PGP-Key-URL: http://www.yoshifuji.org/%7Ehideaki/hideaki@yoshifuji.org.asc
X-Face: "5$Al-.M>NJ%a'@hhZdQm:."qn~PA^gq4o*>iCFToq*bAi#4FRtx}enhuQKz7fNqQz\BYU]
 $~O_5m-9'}MIs`XGwIEscw;e5b>n"B_?j/AkL~i/MEa<!5P`&C$@oP>ZBLP
X-Mailer: Mew version 3.3 on Emacs 20.7 / Mule 4.1 (AOI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <200710032326.FJF32915.OQOOHLMtFSFJFV@I-love.SAKURA.ne.jp> (at Wed, 3 Oct 2007 23:26:57 +0900), Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> says:

> Peter Zijlstra wrote:
> > Also, how do you avoid referencing dead data with your sll? I haven't
> > actually looked at your patches, but the simple scheme you outlined
> > didn't handle the iteration + concurrent removal scenario:
> Regarding my singly-linked list, no entries are removed from the list. It's append only (like CD-R media).
> I set is_deleted flag of a entry instead of removing the entry from the list.

It is not a good practice.  Please free such objects.
BTW, how many objects do you have in the list?

--yoshfuji
