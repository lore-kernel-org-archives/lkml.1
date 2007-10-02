Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbXJBVtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbXJBVtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 17:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbXJBVtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 17:49:12 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:64254 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478AbXJBVtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 17:49:11 -0400
To: jmorris@namei.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org, davem@davemloft.net
Subject: Re: [TOMOYO 14/15](repost) LSM expansion for TOMOYO Linux.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <4701F285.5000206@nttdata.co.jp>
	<4701F5CC.7040209@nttdata.co.jp>
	<Xine.LNX.4.64.0710020653470.28698@us.intercode.com.au>
In-Reply-To: <Xine.LNX.4.64.0710020653470.28698@us.intercode.com.au>
Message-Id: <200710030649.GJE84023.QtFSLOVJMOHOFF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Wed, 3 Oct 2007 06:49:06 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Thank you for your comment.

James Morris wrote:
> I'm guessing you need this to determine the receiving process, rather than 
> the socket (which is available via security_sock_rcv_skb()).
Use of security_sock_rcv_skb() was discussed at http://lkml.org/lkml/2007/8/28/74 ,
and answer is at http://lkml.org/lkml/2007/10/2/56 .

> If so, is this to interactively determine from the user or admin whether 
> the packet should be accepted/denied for the receiving process?
Yes, it is to determine whether the packet should be accepted/denied
based on the receiving process (like what anti-virus software's firewall does).

Regards.

