Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbXJBTab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbXJBTab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 15:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbXJBTaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 15:30:24 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34779 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177AbXJBTaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 15:30:23 -0400
Date: Tue, 2 Oct 2007 12:30:50 -0700
From: Mike Kravetz <kravetz@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: -rt scheduling: wakeup bug?
Message-ID: <20071002193050.GB3162@monkey.ibm.com>
References: <20071001221519.GA20671@monkey.ibm.com> <20071002050632.GB28345@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071002050632.GB28345@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2007 at 07:06:32AM +0200, Ingo Molnar wrote:
> * Mike Kravetz <kravetz@us.ibm.com> wrote:
> > 
> > My observations/debugging/conclusions are based on an earlier version 
> > of the code.  It appears the same code/issue still exists in the most 
> > version.  But, I have not not done any work with the latest version.
> 
> I believe you are right - nice catch of this very nontrivial bug! The 
> patch below is against .23-rc - do you think this fix (of moving the rt 
> wakeup sequence to after the activate_task()) is adequate?

Yes, I have been running with a similar patch on a (much) earlier
version of the code.  It has helped quite a bit.  I would have
put together a patch for a later version, but my test environment
is limited to this earlier version.

-- 
Mike
