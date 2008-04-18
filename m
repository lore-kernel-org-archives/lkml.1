Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbYDRHZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbYDRHZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 03:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbYDRHZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 03:25:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53222 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbYDRHZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 03:25:16 -0400
Date: Fri, 18 Apr 2008 09:24:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: 2.6.25-mm1: not looking good
Message-ID: <20080418072457.GB18044@elte.hu>
References: <20080417160331.b4729f0c.akpm@linux-foundation.org> <84144f020804172340l79f9c815u42e4dad69dada299@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020804172340l79f9c815u42e4dad69dada299@mail.gmail.com>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Andrew, you don't seem to have slab debugging enabled:
> 
> # CONFIG_DEBUG_SLAB is not set
> 
> And quite frankly, the oops looks unlikely to be a slab bug but rather 
> a plain old slab corruption cause by the callers...

hm, there's sel_netnode_free() in the stackframe - that's from 
security/selinux/netnode.c. Andrew, any recent changes in that area?

	Ingo
