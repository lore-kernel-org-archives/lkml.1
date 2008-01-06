Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbYAFJ0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbYAFJ0z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 04:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYAFJ0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 04:26:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40144 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbYAFJ0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 04:26:46 -0500
Date: Sun, 6 Jan 2008 10:26:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, olof@lixom.net, mpm@selenic.com
Subject: Re: [patch 0/5] enhance WARN_ON series
Message-ID: <20080106092619.GA23627@elte.hu>
References: <20080105190713.73745ec6@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080105190713.73745ec6@laptopd505.fenrus.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> 3rd try for this patch series; now with a split up patch for __WARN_ON
> 
> This series has the goal of extending the usefulness of the WARN_ON() 
> information, at least on architectures that use the generic WARN_ON() 
> infrastructure. (Those who do their own thing either already have the 
> extra information, or could consider switching to the generic code). 
> In order to do that, WARN_ON() first needs to be uninlined since 
> there's like 1200 callsites and adding code to each of those isn't 
> pretty.
> 
> As part of this, I had to split the __WARN_ON patch in -mm into 2 
> pieces, one to introduce __WARN_ON, and a separate one to do the ifdef 
> cleanup.

i've added the first 3 patches to x86.git, for further testing - and 
would expect -mm to pick up #4/#5.

	Ingo
