Return-Path: <linux-kernel-owner+w=401wt.eu-S1763239AbZCYRSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763239AbZCYRSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755682AbZCYRSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:18:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60338 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbZCYRSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:18:03 -0400
Date: Wed, 25 Mar 2009 17:17:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Tim Bird <tim.bird@am.sony.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: Anyone working on ftrace function graph support on ARM?
Message-ID: <20090325171727.GH2952@n2100.arm.linux.org.uk>
References: <49C936CA.8070800@am.sony.com> <20090324213618.GC5975@nowhere> <49C95EAF.7030901@gmail.com> <20090324224857.GE5975@nowhere> <20090325084248.GF4697@n2100.arm.linux.org.uk> <49CA5CFF.8090908@am.sony.com> <20090325170533.GA4667@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090325170533.GA4667@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 06:05:33PM +0100, Uwe Kleine-König wrote:
> On Wed, Mar 25, 2009 at 09:34:07AM -0700, Tim Bird wrote:
> > Russell King - ARM Linux wrote:
> > > As pointed out in my previous mail, identifying where on the stack the
> > > return address is stored is only possible for OABI with frame pointers.
> > > 
> > > EABI will probably be possible with the stack unwinding code, but it
> > > probably won't be cheap.  The EABI unwinder is scheduled for merging
> > > during the present now-open merge window.
> EABI with frame pointers should work, too, shouldn't it?

Yes, as I said at the top of my reply dated Wed, 25 Mar 2009 09:57:51 +0000
