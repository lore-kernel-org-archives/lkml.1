Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbYARI7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbYARI7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 03:59:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbYARI7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 03:59:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53585 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbYARI7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 03:59:31 -0500
Date: Fri, 18 Jan 2008 09:59:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>
Subject: Re: x86 refuses to build [Re: 2.6.24-rc8-mm1]
Message-ID: <20080118085913.GD19792@elte.hu>
References: <20080117023514.9df393cf.akpm@linux-foundation.org> <20080117172857.GA24121@linux.vnet.ibm.com> <20080117184406.GA561@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117184406.GA561@linux.vnet.ibm.com>
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


* Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:

> grepping around and looking through the code, I notice it is because 
> these variables just do not exist for 32 bit NUMA. I am not sure how 
> to go about it, and will just leave it to folks who know what they are 
> doing there :).

yes, Mike Travis has i think some patches in the works for this build 
problem. Disabling NUMA on 32-bit is the solution meanwhile.

	Ingo
