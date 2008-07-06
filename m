Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbYGFAj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbYGFAj6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 20:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbYGFAju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 20:39:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46534 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbYGFAjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 20:39:49 -0400
Date: Sat, 5 Jul 2008 20:39:46 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Wolfgang Grandegger <wg@grandegger.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Luotao Fu <l.fu@pengutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1: Strange latencies on mpc5200 powerpc - RCU issue?
In-Reply-To: <486B37BF.6030107@grandegger.com>
Message-ID: <Pine.LNX.4.58.0807052038540.8466@gandalf.stny.rr.com>
References: <47976D06.1010900@grandegger.com> <479DF0A1.3000906@pengutronix.de>
 <479DF711.5090406@grandegger.com> <479F186A.4020004@pengutronix.de>
 <479F2C3C.1020203@grandegger.com> <20080130010716.GB16069@linux.vnet.ibm.com>
 <47A032E9.4080105@grandegger.com> <20080130102255.GA24890@linux.vnet.ibm.com>
 <47A0552D.20605@grandegger.com> <20080130105715.GE24890@linux.vnet.ibm.com>
 <20080130111559.GC20089@pengutronix.de> <486A3EBB.6030905@grandegger.com>
 <Pine.LNX.4.58.0807011036510.26650@gandalf.stny.rr.com> <486B37BF.6030107@grandegger.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2 Jul 2008, Wolfgang Grandegger wrote:

>
> Steven Rostedt wrote:
> > On Tue, 1 Jul 2008, Wolfgang Grandegger wrote:
> >> I continue this thread because it's still not understood why enabling
> >> CONFIG_RCU_TRACE is necessary to get reasonable latencies on the
> >> MPC5200. It might also explain, why I get much worse latencies with
> >> 2.6.25.8-rt7.
> >
> > Have you tried turning on ftrace?
>
> Hm, is it available for PowerPC? I have not found yet how to enable it.

Hmm, should be. But I need to test it on my PPC box first before I can
tell you for sure. If you don't see a way to enable it, perhaps I haven't
updated the config options for PPC yet.

-- Steve

