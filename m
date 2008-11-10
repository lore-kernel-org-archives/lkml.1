Return-Path: <linux-kernel-owner+w=401wt.eu-S1753572AbYKJVxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbYKJVxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 16:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbYKJVxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 16:53:45 -0500
Received: from gate.crashing.org ([63.228.1.57]:48051 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbYKJVxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 16:53:44 -0500
Subject: Re: [Bug #11875] radeonfb lockup in .28-rc (bisected)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andreas Schwab <schwab@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       James Cloos <cloos@jhcloos.com>,
       Paul Collins <paul@burly.ondioline.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <jetzafiad4.fsf@sykes.suse.de>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
	 <wnN9HICUAgP.A._d.f5zFJB@chimera> <1226295985.7731.7.camel@pasglop>
	 <jetzafiad4.fsf@sykes.suse.de>
Content-Type: text/plain
Date: Tue, 11 Nov 2008 08:52:59 +1100
Message-Id: <1226353979.7530.8.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-10 at 21:39 +0100, Andreas Schwab wrote:
> Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
> 
> > radeonfb: Fix accel problems with new imageblit hook
> >
> > Some radeon chips have issues with color expansion of pixmaps that
> > aren't a multiple of 32 pixels wide. This works around it the same
> > way X does by requesting the right pitch alignment from fbcon and
> > then using the chip scissors to do clipping to the requested size.
> 
> Unfortunately this does not fix the suspend regression on PowerBook6,7.
> Instead I have to use the workaround in
> <http://marc.info/?l=linux-kernel&m=122515268301239&w=2>.

Strange. The suspend problem happens also when X hasn't been launched at all ?

Ben.


