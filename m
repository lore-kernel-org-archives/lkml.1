Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbYACKj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbYACKj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 05:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYACKjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 05:39:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33400 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbYACKjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 05:39:21 -0500
Date: Thu, 3 Jan 2008 11:39:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [9/20] x86: Don't use oops_begin in 64bit mce code
Message-ID: <20080103103912.GA29194@elte.hu>
References: <20080103149.088038000@suse.de> <20080103005004.A171C14D40@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103005004.A171C14D40@wotan.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0429]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> It is not really useful to lock machine checks against oopses. And 
> machine checks normally don't nest, so they don't need their own 
> locking. Just call bust_spinlock/console_verbose directly.

is this in response to any particular incident you've seen?

	Ingo
