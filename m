Return-Path: <linux-kernel-owner+w=401wt.eu-S1752022AbYCIMAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbYCIMAX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 08:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbYCIMAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 08:00:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60141 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbYCIMAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 08:00:10 -0400
Date: Sun, 9 Mar 2008 12:59:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.25-rc4
Message-ID: <20080309115947.GA1249@elte.hu>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <20080306090029.GA6215@elte.hu> <20080306125929.GD17940@kernel.dk> <20080306130643.GB21359@elte.hu> <20080307085341.GA23814@elte.hu> <20080308233604.GA3866@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080308233604.GA3866@ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0009]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> How many machines are there in your test farm? Would it be possible to 
> make the neccessary scripts available somewhere? I guess I could make 
> one or two machines do some automated testing...

the thing that took most time to develop were the Kconfig space changes, 
i've released them 2 months ago:

   http://people.redhat.com/mingo/auto-qa-patches/

the scripts that install a bzImage on the target system are boring and 
tied to my environment/hostnames.

with the auto-qa Kconfig patch applied, every "make randconfig" bzImage 
(on x86) is supposed to boot up fine - if it doesnt it's a 
bug/regression. Add entries to arch/x86/Kconfig.needed to force-enable 
drivers that are needed on your boxes.

	Ingo
