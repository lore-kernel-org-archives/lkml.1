Return-Path: <linux-kernel-owner+w=401wt.eu-S1757118AbYJKOhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118AbYJKOhR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 10:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbYJKOhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 10:37:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48000 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396AbYJKOhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 10:37:04 -0400
Date: Sat, 11 Oct 2008 16:36:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Help text for config OPTIMIZE_INLINING
Message-ID: <20081011143653.GB6274@elte.hu>
References: <537458.72510.qm@web38204.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537458.72510.qm@web38204.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0626]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> The main help text for the OPTIMIZE_INLINING kconfig option says: "The 
> gcc 4.x series have a rewritten inlining algorithm and disabling this 
> option will generate a smaller kernel there."
> 
> That suggests that to generate a smaller kernel one should set the 
> option to n. However the short text says: "Allow gcc to uninline 
> functions marked 'inline'"
> 
> While suggests that one should set it to y to generate smaller 
> kernels. My own experience says that setting it to y DOES generate a 
> smaller kernel so perhaps the main text should be changed to reflect 
> this?

sure, could you send a patch (with lkml Cc:-ed) that does this?

Also, would be nice if you sent with/without vmlinux size numbers for 
the config you are using. Btw., do you have 
CONFIG_CC_OPTIMIZE_FOR_SIZE=y enabled as well? That too shrinks the 
kernel (which speeds it up as well on moder CPUs), quite visibly.

	Ingo
