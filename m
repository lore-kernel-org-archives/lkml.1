Return-Path: <linux-kernel-owner+w=401wt.eu-S1758618AbYDDIOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618AbYDDIOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 04:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbYDDIN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 04:13:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36338 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546AbYDDINz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 04:13:55 -0400
Date: Fri, 4 Apr 2008 10:13:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Markus Metzger <markus.t.metzger@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Debug Store - call kfree if only we really need it
Message-ID: <20080404081341.GC30799@elte.hu>
References: <20080401154150.GA7654@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401154150.GA7654@cvg>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2814]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> We should call for kfree if only we really need it. Though it's safe 
> to call kfree with NULL pointer passed in this code we've already 
> tested the pointer and can eliminate the call

thanks, applied.

	Ingo
