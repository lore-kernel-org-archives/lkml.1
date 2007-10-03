Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbXJCNJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbXJCNJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 09:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbXJCNJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 09:09:31 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:51822 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbXJCNJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 09:09:30 -0400
Date: Wed, 03 Oct 2007 22:11:16 +0900 (JST)
Message-Id: <20071003.221116.83306587.yoshfuji@linux-ipv6.org>
To: penguin-kernel@I-love.SAKURA.ne.jp
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, chrisw@sous-sol.org,
       yoshfuji@linux-ipv6.org
Subject: Re: [TOMOYO 05/15](repost) Domain transition handler functions.
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <200710032204.DFF51552.OFOSOFMVQtHLJF@I-love.SAKURA.ne.jp>
References: <20071003.204356.05853536.yoshfuji@linux-ipv6.org>
	<Xine.LNX.4.64.0710030529580.6431@us.intercode.com.au>
	<200710032204.DFF51552.OFOSOFMVQtHLJF@I-love.SAKURA.ne.jp>
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

In article <200710032204.DFF51552.OFOSOFMVQtHLJF@I-love.SAKURA.ne.jp> (at Wed, 3 Oct 2007 22:04:11 +0900), Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> says:

> Well, is there a way to avoid read_lock when reading list?
> 
> Currently, TOMOYO Linux avoids read_lock, on the assumption that
> (1) First, ptr->next is initialized with NULL.
> (2) Later, ptr->next is assigned non-NULL address.
> (3) Assigning to ptr->next is done atomically.

RCU?

--yoshfuji
