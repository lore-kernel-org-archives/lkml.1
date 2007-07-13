Return-Path: <linux-kernel-owner+w=401wt.eu-S936300AbXGMJn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936300AbXGMJn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936757AbXGMJnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:43:09 -0400
Received: from www.osadl.org ([213.239.205.134]:58031 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936744AbXGMJnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:43:06 -0400
Subject: Re: Forward port of latest RT patch (2.6.21.5-rt20) to
	2.6.22	available
From: Thomas Gleixner <tglx@linutronix.de>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Peter Williams <pwil3058@bigpond.net.au>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>, jim.houston@ccur.com,
       joe.korty@ccur.com, rostedt@goodmis.org, dwalker@mvista.com,
       David Bahi <DBahi@novell.com>, Moiz Kohari <MKohari@novell.com>,
       Sven Dietrich <SDietrich@novell.com>, dsaxena@plexity.net,
       williams@redhat.com, abogani@texware.it, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <200707130443.11356.gene.heskett@gmail.com>
References: <4695E5BB0200005A0002763E@mcclure.wal.novell.com>
	 <20070712130958.GB17494@elte.hu> <46971ADC.3030700@bigpond.net.au>
	 <200707130443.11356.gene.heskett@gmail.com>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 11:42:55 +0200
Message-Id: <1184319775.12353.300.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 04:43 -0400, Gene Heskett wrote:
> >> we are working on something in this area :) Stay tuned ...
> >
> >I've just been reviewing these patches and have spotted an error in the
> >file mm/slob.c at lines 500-501 whereby a non existent variable "c" is
> >referenced.  The attached patch is a proposed fix to the problem.
> 
> Could this explain why 2.6.22.1-rt1 seems to use a lot of swap?  I've been as 
> high as 570 megs into swap, currently at 286megs after doing a 
> swapoff --a;swapon -a about 8 hours ago.

No, we disabled SLOB for now. So this is something different.

	tglx


