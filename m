Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbYFGAoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbYFGAoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 20:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYFGAoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 20:44:17 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:45493 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbYFGAoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 20:44:16 -0400
Date: Fri, 6 Jun 2008 17:44:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Corey Minyard <minyard@acm.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, dvhltc@us.ibm.com, niv@us.ibm.com
Subject: Re: Recoverable MCA interrupts from NMI handlers?  IPMI and RCU?
Message-ID: <20080607004411.GI25053@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080606152134.GA13641@linux.vnet.ibm.com> <4849A3AC.5090107@acm.org> <4849D059.1000701@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4849D059.1000701@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 05:03:37PM -0700, H. Peter Anvin wrote:
> Corey Minyard wrote:
> >If you mean the IPMI driver, it does not tie into any SMI.  It 
> >theoretically could since there's a bit for that in the watchdog timer, 
> >but there's been no demand and I haven't looked at it.  I guess it would 
> >be better than an NMI.
> >
> >If it did tie in, it would most likely just panic to get useful 
> >information out before the watchdog reset the system.
> 
> The main reason I could see wanting to use SMI would be as a debugging 
> tool, since SMI makes the entire state of the system available at a low 
> level; however, trying to interact with the state of the kernel at this 
> priority level seems beyond the pale in terms of complexity.

Works for me!  ;-)

							Thanx, Paul
