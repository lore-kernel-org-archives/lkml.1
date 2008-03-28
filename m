Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbYC1Lft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbYC1Lft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 07:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbYC1Lfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 07:35:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53099 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbYC1Lfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 07:35:41 -0400
Date: Fri, 28 Mar 2008 12:35:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: agpgart: when telling user you'll corrupt his data, at least
	do it at KERN_CRIT
Message-ID: <20080328113528.GA8077@elte.hu>
References: <20080328112507.GA10774@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328112507.GA10774@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1190]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> IOMMU off means very bad stuff may happen, like data corruption on 
> your hard drives. At least tells users this is serious...

ouch. Please at minimum lets turn this into a panic(), but best would be 
to trim memory in this case, hm?

	Ingo
