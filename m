Return-Path: <linux-kernel-owner+w=401wt.eu-S935507AbXGMGw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935507AbXGMGw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 02:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759864AbXGMGwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 02:52:18 -0400
Received: from www.osadl.org ([213.239.205.134]:45267 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753973AbXGMGwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 02:52:17 -0400
Subject: Re: Forward port of latest RT patch (2.6.21.5-rt20) to
	2.6.22	available
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       jim.houston@ccur.com, joe.korty@ccur.com, rostedt@goodmis.org,
       dwalker@mvista.com, David Bahi <DBahi@novell.com>,
       Moiz Kohari <MKohari@novell.com>, Sven Dietrich <SDietrich@novell.com>,
       dsaxena@plexity.net, williams@redhat.com, abogani@texware.it,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <46971ADC.3030700@bigpond.net.au>
References: <4695E5BB0200005A0002763E@mcclure.wal.novell.com>
	 <20070712130958.GB17494@elte.hu>  <46971ADC.3030700@bigpond.net.au>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 08:52:13 +0200
Message-Id: <1184309533.12353.295.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 16:25 +1000, Peter Williams wrote:
> > we are working on something in this area :) Stay tuned ...
> 
> I've just been reviewing these patches and have spotted an error in the
> file mm/slob.c at lines 500-501 whereby a non existent variable "c" is
> referenced.  The attached patch is a proposed fix to the problem.

Yep, the slob forward port is incomplete. Your patch is definitely more
correct than the stuff which is currently there.

Thanks,

	tglx


