Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbXLDNU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbXLDNU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 08:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbXLDNUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 08:20:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50405 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbXLDNUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 08:20:14 -0500
Date: Tue, 4 Dec 2007 14:19:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] Add the word 'Warning' in check_nmi_watchdog()
	output
Message-ID: <20071204131953.GH31590@elte.hu>
References: <1196090406-6952-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196090406-6952-1-git-send-email-dzickus@redhat.com>
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


* Don Zickus <dzickus@redhat.com> wrote:

> Our automated test suite looks for keywords like error, fail, warning 
> in the boot log.  In the case when the nmi watchdog is determined to 
> be stuck in check_nmi_watchdog(), none of those keywords are 
> displayed.
> 
> This patch adds a keyword, 'Warning, so it makes it easier to notice 
> when the nmi watchdog isn't working correctly.
> 
> No technical changes have been made.  Compiler tested.
> 
> Signed-off-by: Don Zckus <dzickus@redhat.com>

thanks, i've picked this up into the x86 tree for .24 merge.

	Ingo
