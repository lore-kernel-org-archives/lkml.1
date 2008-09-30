Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025AbYI3IMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbYI3IMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 04:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbYI3ILv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 04:11:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52993 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbYI3ILu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 04:11:50 -0400
Date: Tue, 30 Sep 2008 10:11:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: mtrr_cleanup prepare to make gran_size to
	less 1M
Message-ID: <20080930081141.GA29840@elte.hu>
References: <1222739652-17169-1-git-send-email-yhlu.kernel@gmail.com> <48E1A5E8.3030304@zytor.com> <20080930074552.GA19366@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080930074552.GA19366@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > Applied series to tip:x86/mtrr, thanks!
> 
> tested them and pushed it out into tip/master.

btw., now that we've got wide enough exposure (a kernel release), could 
we please flip around the default of CONFIG_MTRR_SANITIZER and make it 
default-y? This feature should only produce a worse result if there's a 
bug in that code, right?

	Ingo
