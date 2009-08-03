Return-Path: <linux-kernel-owner+w=401wt.eu-S1755039AbZHCM53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039AbZHCM53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 08:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbZHCM53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 08:57:29 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56724 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786AbZHCM52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 08:57:28 -0400
Date: Mon, 3 Aug 2009 05:56:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org, ego@in.ibm.com
Subject: Re: [tip:core/rcu] rcu: Add diagnostic check for a possible
	CPU-hotplug race
Message-ID: <20090803125618.GV6854@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <tip-7256cf0e83bf018be8a81806593aaef7f2437f0b@git.kernel.org> <20090802202720.GA32360@elte.hu> <20090802221324.GP6854@linux.vnet.ibm.com> <20090803070458.GA27581@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090803070458.GA27581@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 09:04:58AM +0200, Ingo Molnar wrote:
> 
> i've attached the full serial bootlog with the warning in it. This 
> should address your question about what the order of initialization 
> is, right?

It does, thank you!  This problem really is happening during boot.

> Let me know if you still would like me to run your diagnostic patch 
> too.

Now that you mention it, you should probably let me test it a bit first.

							Thanx, Paul
