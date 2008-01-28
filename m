Return-Path: <linux-kernel-owner+w=401wt.eu-S1759640AbYA1JYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640AbYA1JYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 04:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbYA1JY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 04:24:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54951 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198AbYA1JYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 04:24:25 -0500
Date: Mon, 28 Jan 2008 10:24:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Jason Wessel <jason.wessel@windriver.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net
Subject: Re: [RFC PATCH] KGDB: various refactorings
Message-ID: <20080128092411.GA4774@elte.hu>
References: <479CD13D.7070703@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479CD13D.7070703@web.de>
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


* Jan Kiszka <jan.kiszka@web.de> wrote:

> Things I changed:
>  - Reduce EXPORT_SYMBOLs, switch the rest to EXPORT_SYMBOL_GPL
>  - Drop code that is (yet) unused
>  - Rename variables, refactor their types (personal taste, for sure)
>  - Remove "extern" for function prototypes
>  - Remove MODULE_LICENSE/DESCRIPTION from kgdb core

thanks, applied - these look like very sensible cleanups prior merge.

	Ingo
