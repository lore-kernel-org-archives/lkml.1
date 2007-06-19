Return-Path: <linux-kernel-owner+w=401wt.eu-S933404AbXFSTQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404AbXFSTQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933252AbXFSTPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:15:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43072 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933237AbXFSTPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:15:32 -0400
Date: Tue, 19 Jun 2007 12:15:31 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       suresh.b.siddha@intel.com, pwil3058@bigpond.net.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: v2.6.21.4-rt11
In-Reply-To: <20070619143331.GH17865@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0706191215220.7008@schroedinger.engr.sgi.com>
References: <20070613185522.GA27335@elte.hu> <20070613233910.GJ8125@linux.vnet.ibm.com>
 <20070615144535.GA12078@elte.hu> <20070615151452.GC9301@linux.vnet.ibm.com>
 <20070615195545.GA28872@elte.hu> <20070616011605.GH9301@linux.vnet.ibm.com>
 <20070616084434.GG2559@linux.vnet.ibm.com> <20070616161213.GA2994@linux.vnet.ibm.com>
 <20070618151215.GA9750@linux.vnet.ibm.com> <20070619090430.GA7471@elte.hu>
 <20070619143331.GH17865@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007, Srivatsa Vaddagiri wrote:

> On Tue, Jun 19, 2007 at 11:04:30AM +0200, Ingo Molnar wrote:
> > I'm wondering, why did this trigger under CFS and not on mainline? 
> > Mainline seems to have a similar problem in idle_balance() too, or am i 
> > misreading it?
> 
> The problem is there in mainline very much. I could recreate the problem
> with 2.6.22-rc5 (which doesnt have CFS) on that same hardware, with
> CONFIG_NUMA enabled.
> 
> Let me know if you needed anything else to be clarified.

This is a bugfix that needs to go into 2.6.22.

