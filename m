Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbYINPZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbYINPZj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 11:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbYINPZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 11:25:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56610 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137AbYINPZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 11:25:30 -0400
Date: Sun, 14 Sep 2008 17:25:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Alex Nixon <alex.nixon@citrix.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] redefine resource_size_t as phys_addr_t
Message-ID: <20080914152512.GG29290@elte.hu>
References: <48C8D776.1020204@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C8D776.1020204@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0102]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> There's no good reason why a resource_size_t shouldn't just be a 
> physical address, so simply redefine it in terms of phys_addr_t.

i've applied your patchset to tip/core/resources:

 8308c54: generic: redefine resource_size_t as phys_addr_t
 947d049: generic: make PFN_PHYS explicitly return phys_addr_t
 600715d: generic: add phys_addr_t for holding physical addresses

thanks,

	Ingo
