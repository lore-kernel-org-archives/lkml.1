Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbYC1JA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbYC1JA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 05:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbYC1JAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 05:00:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58462 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355AbYC1JAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 05:00:13 -0400
Date: Fri, 28 Mar 2008 09:59:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ben Castricum <lk08@bencastricum.nl>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [TRIVIAL PATCH] Microcode: show results on success too
Message-ID: <20080328085958.GD21413@elte.hu>
References: <alpine.LNX.1.10.0803272041450.11972@gateway.bencastricum.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0803272041450.11972@gateway.bencastricum.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1241]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ben Castricum <lk08@bencastricum.nl> wrote:

> Report when microcode was successfully updated. It used to be there 
> but now with DEBUG unset it becomes very silent. Also some cosmetic 
> fixes.

thanks Ben, applied.

> This is take 2 of the patch. Thanks for the feedback on the first one. 
> It is now sent with a decent mailer. It is also a bit larger since I 
> made the debug message more consistent.

looks good. A tiny detail for future patches, please prefix x86 patches 
with "x86: " and make it lowercase, i.e. use:

 Subject: [patch] x86: microcode: show results on success too

instead of:

 Subject: [TRIVIAL PATCH] Microcode: show results on success too

	Ingo
