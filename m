Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbZLAKzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbZLAKzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 05:55:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbZLAKzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 05:55:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:39803 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbZLAKzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 05:55:07 -0500
Subject: Re: [RFC] [PATCH 0/2] Futex fault injection
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sripathi Kodi <sripathik@in.ibm.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <20091201103351.GA6685@elte.hu>
References: <20091201141642.398e7b7d@sripathi>
	 <20091201103351.GA6685@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Dec 2009 11:54:43 +0100
Message-ID: <1259664883.1697.28.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-01 at 11:33 +0100, Ingo Molnar wrote:
> * Sripathi Kodi <sripathik@in.ibm.com> wrote:
> 
> > Hi,
> > 
> > This patch set adds fault injection for futex subsystem. It adds 
> > faults at places where reading/writing from user space can return 
> > EFAULT. This will be useful in testing any significant change to futex 
> > subsystem.
> 
> Instead of this unacceptably ugly and special-purpose debugfs interface, 
> please extend perf events to allow event injection. Some other places in 
> the kernel (which deal with rare events) want/need this capability too.

Thing is, he's using the 'normal' fault injection code to do this, I see
no objection to doing that.

If you want to redo the fault injection subsystem, then that's another
story, but then we need to convert all of its users over.

