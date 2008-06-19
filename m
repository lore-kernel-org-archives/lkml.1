Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbYFSLfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbYFSLfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 07:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbYFSLff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 07:35:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47590 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754355AbYFSLff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 07:35:35 -0400
Date: Thu, 19 Jun 2008 13:34:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, tglx@linutronix.de, hpa@zytor.com,
       Mike Travis <travis@sgi.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2] MM: virtual address debug
Message-ID: <20080619113436.GL15228@elte.hu>
References: <20080618135928.GA12803@elte.hu> <1213814136-10812-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213814136-10812-1-git-send-email-jirislaby@gmail.com>
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


* Jiri Slaby <jirislaby@gmail.com> wrote:

> I've removed the test from phys_to_nid and made a function from __phys_addr
> only when the debugging is enabled (on x86_32).

applied to tip/x86/mm-debug for more testing. Please send future updates 
as a delta against that branch, it includes a cleanup patch as well. 
Thanks,

	Ingo
