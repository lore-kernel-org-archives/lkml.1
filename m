Return-Path: <linux-kernel-owner+w=401wt.eu-S1758409AbYDRHJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409AbYDRHJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 03:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbYDRHJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 03:09:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45050 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611AbYDRHJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 03:09:40 -0400
Date: Fri, 18 Apr 2008 09:09:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: 2.6.25-mm1: not looking good
Message-ID: <20080418070913.GA16599@elte.hu>
References: <20080417160331.b4729f0c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417160331.b4729f0c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> I repulled all the trees an hour or two ago, installed everything on an
> 8-way x86_64 box and:
> 
> 
> stack-protector:
> 
> Testing -fstack-protector-all feature
> No -fstack-protector-stack-frame!
> -fstack-protector-all test failed

that's the stackprotector self-test: you probably have a gcc that cannot 
build a proper stackprotector kernel. No damage other than having no 
stackprotector. Arjan Cc:-ed.

	Ingo
