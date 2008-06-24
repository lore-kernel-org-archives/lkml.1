Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbYFXMSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbYFXMSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 08:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbYFXMR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 08:17:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42794 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757840AbYFXMRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 08:17:55 -0400
Date: Tue, 24 Jun 2008 14:17:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: JAILLET Christophe <jaillet.christophe@wanadoo.fr>
Cc: linux <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 1/1] arch/x86/kernel/io_apic_32.c : use kzalloc instead
	of kmalloc/memset
Message-ID: <20080624121743.GA12101@elte.hu>
References: <485E77CC.20604@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485E77CC.20604@wanadoo.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* JAILLET Christophe <jaillet.christophe@wanadoo.fr> wrote:

> From: Christophe Jaillet <jaillet.?christophe@wanadoo.fr>
>
> Hi, here is a patch against arch/x86/kernel/io_apic_32.c which :
>
> 1) replace kmalloc/memset with equivalent kzalloc.

applied to tip/x86/apic - thanks Christophe.

There were some other changes in this area so i did a manual merge of 
your changes. You can see/track your commit via tip/master:

  http://people.redhat.com/mingo/tip.git/README

	Ingo
