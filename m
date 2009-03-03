Return-Path: <linux-kernel-owner+w=401wt.eu-S1755125AbZCCNET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbZCCNET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 08:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZCCNEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 08:04:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:36398 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbZCCNEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 08:04:09 -0500
Subject: Re: [TIP][RFC 3/7] futex: futex_lock_pi_atomic()
From: Peter Zijlstra <peterz@infradead.org>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: "lkml," <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <srostedt@redhat.com>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
In-Reply-To: <49AC761C.907@us.ibm.com>
References: <49AC73A9.4040804@us.ibm.com>  <49AC761C.907@us.ibm.com>
Content-Type: text/plain
Date: Tue, 03 Mar 2009 14:03:58 +0100
Message-Id: <1236085438.5330.4336.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 16:13 -0800, Darren Hart wrote:
> + * Returns:
> + * - 0 on success (futex_q is setup and FUTEX_WAITERS bit is set on the futex)
> + * - 1 on a successful atomic acquisition of the lock
> + * - A negative error code on failure

That utterly confused me for a while.

Maybe something like:

 0 - ready to wait
 1 - acquired the lock
 
 <0 - error

