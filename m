Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbYHVF41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbYHVF41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 01:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbYHVF4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 01:56:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55015 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbYHVF4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 01:56:19 -0400
Date: Fri, 22 Aug 2008 07:55:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: fix two modpost warnings in mm/init_64.c
Message-ID: <20080822055559.GB14110@elte.hu>
References: <48AD89AA.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AD89AA.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0265]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <jbeulich@novell.com> wrote:

> early_io{re,un}map() are __init and hence can't be called from 
> __meminit functions.

applied to tip/x86/urgent - thanks Jan!

	Ingo
