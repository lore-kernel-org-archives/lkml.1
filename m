Return-Path: <linux-kernel-owner+w=401wt.eu-S1765950AbYBBRKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765950AbYBBRKv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 12:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbYBBRKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 12:10:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57963 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbYBBRKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 12:10:43 -0500
Date: Sat, 2 Feb 2008 18:10:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [scsi bug] spurious build failures in aic7xxx
Message-ID: <20080202171020.GB12748@elte.hu>
References: <20080201225056.GA18302@elte.hu> <20080202135935.GA23838@uranus.ravnborg.org> <20080202140326.GA6544@elte.hu> <20080202140630.GA7939@elte.hu> <20080202141857.GA8635@elte.hu> <20080202162611.GA24765@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202162611.GA24765@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> I could not reproduce the bug myself but I think I spotted it. We had 
> a missing dependency to the _reg.h file. Try following patch and let 
> me now if it continue to break.

thanks! I threw this into the test setup and will know by tomorrow 
whether there's any breakage.

	Ingo
