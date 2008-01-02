Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbYABUSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbYABUSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755835AbYABUSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:18:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48808 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508AbYABUSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:18:08 -0500
Date: Wed, 2 Jan 2008 21:17:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Brownell <david-b@pacbell.net>
Cc: rjw@sisk.pl, a.zummo@towertech.it, stern@rowland.harvard.edu,
       pavel@suse.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       lenb@kernel.org, gregkh@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH 0/4] PM: Do not destroy/create devices while suspended
	(rev. 2)
Message-ID: <20080102201707.GD3985@elte.hu>
References: <200801020032.45529.rjw@sisk.pl> <20080102105217.GA14731@elte.hu> <200801021356.59865.rjw@sisk.pl> <20080102131529.GA32160@elte.hu> <20080102172625.CE0C2F6DFE@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102172625.CE0C2F6DFE@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
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


* David Brownell <david-b@pacbell.net> wrote:

> > shouldnt we provide a Kconfig way of replacing dev 10:135 with the 
> > new driver's 254:0 device? (while keeping all the current modes of 
> > operation as well, of course.)
> 
> The major number 254 is not statically allocated, ISTR; that should be 
> managed only by udev.

sorry, i meant a .config option that would cause 10:135 to be managed by 
the new RTC code too. (Config option can be default-off.)

	Ingo
