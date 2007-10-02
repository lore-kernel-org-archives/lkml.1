Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbXJBM7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbXJBM7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 08:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbXJBM7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 08:59:03 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:51258 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbXJBM67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 08:58:59 -0400
Date: Tue, 02 Oct 2007 22:00:43 +0900 (JST)
Message-Id: <20071002.220043.89768361.yoshfuji@linux-ipv6.org>
To: penguin-kernel@I-love.SAKURA.ne.jp
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, chrisw@sous-sol.org,
       yoshfuji@linux-ipv6.org
Subject: Re: [TOMOYO 05/15](repost) Domain transition handler functions.
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <200710022144.BFF09817.VFFOOJLSFHtQMO@I-love.SAKURA.ne.jp>
References: <4701F419.8080103@nttdata.co.jp>
	<Xine.LNX.4.64.0710020355260.6760@us.intercode.com.au>
	<200710022144.BFF09817.VFFOOJLSFHtQMO@I-love.SAKURA.ne.jp>
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

In article <200710022144.BFF09817.VFFOOJLSFHtQMO@I-love.SAKURA.ne.jp> (at Tue, 2 Oct 2007 21:44:57 +0900), Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> says:

> If I use "struct hlist_node" which has two pointers,
> it needs more memory than "struct something" which has one pointer.
> It is possible to use API defined in include/linux/list.h ,
> but to reduce memory usage, I dare not use these API.
> Singly-linked list's rule in TOMOYO Linux is quite simple,
> "ptr->next is NULL if the last element" and "non-NULL if not".

Introducing your own list is not good.
Please use hlist or introduce new "slist".

--yoshfuji
