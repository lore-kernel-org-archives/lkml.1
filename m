Return-Path: <linux-kernel-owner+w=401wt.eu-S933206AbXFSTPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933206AbXFSTPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933112AbXFSTPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:15:04 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43017 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933072AbXFSTPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:15:03 -0400
Date: Tue, 19 Jun 2007 12:14:59 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       suresh.b.siddha@intel.com, pwil3058@bigpond.net.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: v2.6.21.4-rt11
In-Reply-To: <20070619090430.GA7471@elte.hu>
Message-ID: <Pine.LNX.4.64.0706191214440.7008@schroedinger.engr.sgi.com>
References: <20070613184741.GC8125@linux.vnet.ibm.com> <20070613185522.GA27335@elte.hu>
 <20070613233910.GJ8125@linux.vnet.ibm.com> <20070615144535.GA12078@elte.hu>
 <20070615151452.GC9301@linux.vnet.ibm.com> <20070615195545.GA28872@elte.hu>
 <20070616011605.GH9301@linux.vnet.ibm.com> <20070616084434.GG2559@linux.vnet.ibm.com>
 <20070616161213.GA2994@linux.vnet.ibm.com> <20070618151215.GA9750@linux.vnet.ibm.com>
 <20070619090430.GA7471@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007, Ingo Molnar wrote:

> I'm wondering, why did this trigger under CFS and not on mainline? 
> Mainline seems to have a similar problem in idle_balance() too, or am i 
> misreading it?

Right. The patch needs to go into mainline as well.

