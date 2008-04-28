Return-Path: <linux-kernel-owner+w=401wt.eu-S936325AbYD1RQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936325AbYD1RQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933982AbYD1RQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:16:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56766 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933824AbYD1RQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:16:12 -0400
Date: Mon, 28 Apr 2008 19:16:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix early-BUG message
Message-ID: <20080428171602.GB23620@elte.hu>
References: <20080425190234.GA9525@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080425190234.GA9525@damson.getinternet.no>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> The .asciz directive takes any number of strings, but each one is 
> zero- terminated, and string pasting is not done as in C. That results 
> in only the first line being output.
> 
> Replace .asciz with multiple .ascii directives and terminate with 
> .asciz.

applied, thanks Vegard.

	Ingo
