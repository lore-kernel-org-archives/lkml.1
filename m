Return-Path: <linux-kernel-owner+w=401wt.eu-S1759417AbYHSVsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417AbYHSVsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbYHSVsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:48:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:49002 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbYHSVsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:48:30 -0400
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Eran Liberty <liberty@extricom.com>, Steven Rostedt <srostedt@redhat.com>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linuxppc-dev@ozlabs.org, rostedt@goodmis.org
In-Reply-To: <20080819130216.GA18001@Krystal>
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com>
	 <48A9901B.1080900@redhat.com> <48A9BEA3.10906@extricom.com>
	 <20080818184158.GA1798@Krystal> <48AA98E4.6060606@extricom.com>
	 <20080819130216.GA18001@Krystal>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 07:46:44 +1000
Message-Id: <1219182404.7826.14.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Register GPR30 is always zero... (also true for the other oops)

>From my experiments, -a- non volatile register gets corrupted. Not
always the same and not always with the same value.

The corruption -seems- to happen due to corruption of the location on
the stack where it was saved to / restored from in a previous function
call or interrupt.

I haven't yet tracked down what actually whacks the stack.

Ben.


