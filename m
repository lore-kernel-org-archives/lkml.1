Return-Path: <linux-kernel-owner+w=401wt.eu-S1763030AbYBCLZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763030AbYBCLZZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 06:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756055AbYBCLZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 06:25:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43093 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755968AbYBCLZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 06:25:14 -0500
Date: Sun, 3 Feb 2008 12:25:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "A.E.Lawrence" <lawrence_a_e@ntlworld.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: restore correct module name for apm
Message-ID: <20080203112504.GB9133@elte.hu>
References: <47A4E70D.1000607@ntlworld.com> <20080203103213.GC20810@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203103213.GC20810@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> The apm module were renamed to apm_32 during the merge of 32 and 64 
> bit x86 which is unfortunate. As apm is 32 bit specific we like to 
> keep the _32 in the filename but the module should be named apm.
> 
> Fix this in the Makefile.

thanks, applied.

	Ingo
