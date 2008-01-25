Return-Path: <linux-kernel-owner+w=401wt.eu-S1759700AbYAYW26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759700AbYAYW26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 17:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbYAYW2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 17:28:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48540 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbYAYW2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 17:28:49 -0500
Date: Fri, 25 Jan 2008 23:28:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] [KGDB] core code cleanups
Message-ID: <20080125222836.GA24708@elte.hu>
References: <479A5C35.6040605@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479A5C35.6040605@windriver.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0097]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Wessel <jason.wessel@windriver.com> wrote:

> This patch is against the x86-git which included the kgdb core.
> 
> Per review request from the x86-git maintainers, the kgdb-core has had 
> the kgdb_handle_exception() separated into individual functions.  This 
> patch does nothing other than re-organize the code.  There are no 
> functional kgdb changes.
> 
> kgdb_handle_exception now calls gdb_serial_stub() to handle the 
> debugger communications.  The gdb_serial_stub() has call out to sub 
> handlers for all the major gdb serial packet types.

thanks Jason, i have applied your cleanups to x86.git.

	Ingo
