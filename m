Return-Path: <linux-kernel-owner+w=401wt.eu-S1750914AbXCFUbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750914AbXCFUbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 15:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbXCFUbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 15:31:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60643 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbXCFUbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 15:31:19 -0500
Date: Tue, 6 Mar 2007 21:30:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Gerd Hoffmann <kraxel@suse.de>,
       virtualization <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: Xen & VMI?
Message-ID: <20070306203018.GA21736@elte.hu>
References: <1173101297.26165.39.camel@localhost.localdomain> <1173142644.4644.6.camel@localhost.localdomain> <45ECBDDC.8080708@vmware.com> <45ECC076.9050209@goop.org> <45ECC91D.1020809@vmware.com> <45ECC9B6.1060209@goop.org> <20070306081909.GA9331@elte.hu> <45ED2837.3020108@suse.de> <20070306085222.GA17002@elte.hu> <20070306194612.GG19575@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306194612.GG19575@sequoia.sous-sol.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Wright <chrisw@sous-sol.org> wrote:

> What are you driving at?  You seem to be arguing that abstractions are 
> bad unless done via ABI's. [...]

i'm still arguing the same: that doing the same thing via overlapping, 
conflicting, redundant ABIs is crazy and contrary to the basic interests 
of Linux. It's like having 5 different, parallel variants of sys_open(), 
interfaced via a convoluted open_ops.

having data ABI coupling is one thing (filesystems, network formats, 
etc.). But having a 5-way function ABI coupling between system software 
running on the /same piece of hardware/, doing the same thing in essence 
is just madness in my book.

	Ingo
