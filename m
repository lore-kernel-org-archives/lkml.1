Return-Path: <linux-kernel-owner+w=401wt.eu-S932972AbZE0W0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972AbZE0W0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759608AbZE0W0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:26:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51073 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759670AbZE0W0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:26:38 -0400
Date: Thu, 28 May 2009 00:25:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, jeremy@goop.org, x86@kernel.org,
       linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       gregkh@suse.de, jens.axboe@oracle.com, chrisw@redhat.com,
       kurt.hackel@oracle.com, akpm@linux-foundation.org,
       ksrinivasan@novell.com, jbeulich@novell.com, avi@redhat.com,
       jeremy.fitzhardinge@citrix.com
Subject: Re: [PATCH 17/17] xen: disable MSI
Message-ID: <20090527222520.GA26193@elte.hu>
References: <1243409850-21577-1-git-send-email-jeremy@goop.org> <1243409850-21577-18-git-send-email-jeremy@goop.org> <alpine.LFD.2.01.0905270829530.3435@localhost.localdomain> <20090527.134006.241271867.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527.134006.241271867.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* David Miller <davem@davemloft.net> wrote:

> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Wed, 27 May 2009 08:34:22 -0700 (PDT)
> 
> > I hate them. They are stupid. 90% of all the impact lines I see 
> > are either (a) misleading or (b) totally inane and pointless.
> 
> I just delete any Impact lines I see in patches sent to me, and I 
> honestly suggest you do so as well.

Still you committed a fair number of them already:

earth4:~/tip> git log net/ | grep Impact:
    [...]
    Impact: Attribute functions with __acquires(...) resp. __releases(...).
    Impact: Attribute function with __releases(...)
    Impact: Remove redundant variable declarations, resp. rename
    Impact: Attribute functions with __acquires(...) resp. __releases(...).
    Impact: Include header file.
    Impact: Use 'static const char[]' instead of 'static char[]', and
    Impact: Trust in the comment and add '__force' to the cast.
    Impact: Attribute function with __acquires(...) resp. __releases(...).

btw., these are one of the weirdest impact lines i've ever seen.

You seem to dismiss them unconditionally and indiscriminately, 
without giving any thought to why good impact lines might be useful. 

Good impact lines _are_ really useful to me in my everyday 
maintenance workflow - while bad impact lines indeed are not.
So i try to commit and pull good ones only.

I challenge you to count the number of bad impact lines in the 
current pending x86-next tree, compared to the number of good impact 
lines there.

	Ingo
