Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731AbZBEOaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbZBEOaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 09:30:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbZBEOaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 09:30:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47068 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbZBEOaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 09:30:00 -0500
Date: Thu, 5 Feb 2009 15:29:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: __supported_pte_mask breaks PROT_NONE pages
Message-ID: <20090205142912.GE28443@elte.hu>
References: <498A5002.9080408@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498A5002.9080408@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> On an x86 system which doesn't support global mappings,  
> __supported_pte_mask has _PAGE_GLOBAL clear, to make sure it never  
> appears in the PTE.  pfn_pte() and so on will enforce it with:

btw., did you actually see a boot crash due to this, on a pre-PGE system?

	Ingo
