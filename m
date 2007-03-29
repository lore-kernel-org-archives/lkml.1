Return-Path: <linux-kernel-owner+w=401wt.eu-S933916AbXC2ALh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933916AbXC2ALh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 20:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933896AbXC2ALh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 20:11:37 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36363 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933916AbXC2ALg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 20:11:36 -0400
Date: Wed, 28 Mar 2007 17:01:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel <linux-kernel@vger.kernel.org>, davej@codemonkey.org.uk,
       johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Add support for deferrable timers (respun-Mar28)
Message-Id: <20070328170159.7fc8c289.akpm@linux-foundation.org>
In-Reply-To: <20070328230021.GA29774@linux-os.sc.intel.com>
References: <200703212353.l2LNrNOj007453@shell0.pdx.osdl.net>
	<20070322140532.GA120@tv-sign.ru>
	<20070322151817.GA29840@linux-os.sc.intel.com>
	<20070322161355.GA160@tv-sign.ru>
	<20070327204344.GA21529@linux-os.sc.intel.com>
	<20070327211145.GB216@tv-sign.ru>
	<20070327215542.GA27408@linux-os.sc.intel.com>
	<20070327222227.GA279@tv-sign.ru>
	<20070328230021.GA29774@linux-os.sc.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007 16:00:21 -0700
Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> Please drop the patch you included yesterday and two incremental patches and
> use the patch below.

As you saw, I went and turned it into an incremental patch again.  It makes
it easier to see what changed, but harder to see the whole thing.

> Introduce a new flag for timers - deferrable:

OK, but there's nothing in-kernel whcih actually uses this.

It would be good to identify some timer users which can be switched over (as
many as possible, really) so this thing actually gets some runtime testing.
