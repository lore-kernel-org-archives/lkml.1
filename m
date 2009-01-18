Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbZARSwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbZARSwh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 13:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZARSw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 13:52:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38296 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbZARSw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 13:52:26 -0500
Date: Sun, 18 Jan 2009 19:52:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip v3] fix 39 'make headers_check' warnings
Message-ID: <20090118185200.GA27709@elte.hu>
References: <1232287474.3130.19.camel@localhost.localdomain> <20090118172800.GB22624@elte.hu> <20090118185034.GA26908@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090118185034.GA26908@elte.hu>
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

> why does such a change introduce new code? It is duplicating existing 
> code instead of cleaning it all up.

this has the same problem too:

 #ifdef CONFIG_BINFMT_SHARED_FLAT
 #define        MAX_SHARED_LIBS                 (4)
 #else
 #define        MAX_SHARED_LIBS                 (1)
 #endif
+#else /* __KERNEL__ */
+#define        MAX_SHARED_LIBS                 (1)
+#endif /* __KERNEL__ */

	Ingo
