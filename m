Return-Path: <linux-kernel-owner+w=401wt.eu-S1764525AbYCDVVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764525AbYCDVVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 16:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757849AbYCDVUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 16:20:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38283 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759997AbYCDVUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 16:20:54 -0500
Date: Tue, 4 Mar 2008 22:20:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Roskin <proski@gnu.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Zan Lynx <zlynx@acm.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
	symbols
Message-ID: <20080304212023.GD31546@elte.hu>
References: <1204305609.21719.16.camel@dv> <alpine.LFD.1.00.0802290929590.17889@woody.linux-foundation.org> <1204313978.2316.8.camel@dv> <20080229211513.GI27212@elte.hu> <1204324265.2316.70.camel@dv> <20080303105752.GA23594@elte.hu> <20080304003723.z79pcavdk4wgoc44@webmail.spamcop.net> <20080304125744.GF29777@elte.hu> <alpine.LFD.1.00.0803040907420.12253@woody.linux-foundation.org> <1204652732.2312.18.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204652732.2312.18.camel@dv>
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


* Pavel Roskin <proski@gnu.org> wrote:

> To recap:
> 
> 1) USB API
> 2) Workqueue API (there is a hackish replacement in ndiswrapper)
> 3) task_nice(), but I have a trivial workaround for that.

task_nice() - it's trivial so feel free to send a patch that turns it 
into EXPORT_SYMBOL().

	Ingo
