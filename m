Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbYCUNAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbYCUNAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 09:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbYCUM7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 08:59:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38597 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995AbYCUM7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 08:59:54 -0400
Date: Fri, 21 Mar 2008 13:59:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: ak@suse.de, kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: Re: fix aperture vs. suspend problem
Message-ID: <20080321125939.GD27245@elte.hu>
References: <20080313100531.GA3399@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313100531.GA3399@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0508]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> aperture_64.c takes a piece of memory and makes it into iommu 
> window... but such window may not be saved by swsusp -- that leads to 
> oops during suspend.

nice catch! applied.

	Ingo
