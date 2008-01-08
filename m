Return-Path: <linux-kernel-owner+w=401wt.eu-S1759484AbYAHL2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484AbYAHL2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 06:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbYAHL2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 06:28:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48961 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbYAHL2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 06:28:13 -0500
Date: Tue, 8 Jan 2008 12:27:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: sam@ravnborg.org, ariveira@gmail.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Label x86 do_fork_idle() with __cpuinit
Message-ID: <20080108112753.GA11083@elte.hu>
References: <20080108112326.6524.86229.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108112326.6524.86229.stgit@warthog.procyon.org.uk>
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


* David Howells <dhowells@redhat.com> wrote:

> Label x86 do_fork_idle() with __cpuinit to avoid getting linker 
> warnings when it references fork_idle().  Also make it static.

Thomas is already working on this and has a patch for this and for other 
linker warnings.

	Ingo
