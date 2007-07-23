Return-Path: <linux-kernel-owner+w=401wt.eu-S1765852AbXGWT4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765852AbXGWT4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762466AbXGWTzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:55:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41157 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761974AbXGWTzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:55:52 -0400
Date: Mon, 23 Jul 2007 21:55:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt] temporary WARN_ON removal
Message-ID: <20070723195548.GA10445@elte.hu>
References: <1185124961.2573.14.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185124961.2573.14.camel@imap.mvista.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> These two WARN_ON calls send my system into a boot hang. They trigger 
> over and over , some examples below.

hm, could you try to figure out why they trigger on your box and not on 
anyone else's box? By disabling them we might be papering over a 
potential problem.

	Ingo
