Return-Path: <linux-kernel-owner+w=401wt.eu-S1763939AbYCDMVC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763939AbYCDMVC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 07:21:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbYCDMUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 07:20:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48539 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729AbYCDMUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 07:20:51 -0500
Date: Tue, 4 Mar 2008 13:20:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, jikos@suse.cz, jack@suse.cz
Subject: Re: wmb() confusion in system.h
Message-ID: <20080304122037.GA29777@elte.hu>
References: <20080303114909.GA23816@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303114909.GA23816@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0050]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> Comment says wmb is a nop, but it is implemented as lock addl below... 
> Should it be compiled to nop if we know we are running on "good" Intel 
> cpu?
> 
> At least remove confusing comment for now.

agreed - that comment is pretty much out of date. I've applied your 
patch.

	Ingo
