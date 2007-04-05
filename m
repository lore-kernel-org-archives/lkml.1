Return-Path: <linux-kernel-owner+w=401wt.eu-S1767228AbXDETHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767228AbXDETHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 15:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767222AbXDETHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 15:07:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59821 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767218AbXDETHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 15:07:24 -0400
Date: Thu, 5 Apr 2007 21:07:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masayuki Nakagawa <nakagawa.msy@ncos.nec.co.jp>
Cc: linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2.6.21-rc5-rt12] IPV6: Flag bit of ebitmask is not set in __inet6_hash.
Message-ID: <20070405190714.GB22092@elte.hu>
References: <461543B5.6080605@ncos.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461543B5.6080605@ncos.nec.co.jp>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Masayuki Nakagawa <nakagawa.msy@ncos.nec.co.jp> wrote:

> I found an issue with -rt patch. It is that netstat doesn't show IPv6 
> sockets in ESTABLISHED state. This issue happens because a flag bit of 
> ebitmask is not set when the IPv6 socket connection is established.
> 
> The fix is to set the flag bit in __inet6_hash().

thanks. I'm wondering, should this fix be done in mainline too? -rt12 is 
based on Linus' -git kernel from yesterday.

	Ingo
