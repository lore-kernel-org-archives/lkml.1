Return-Path: <linux-kernel-owner+w=401wt.eu-S1752234AbXCEWFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbXCEWFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:05:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbXCEWFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:05:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbXCEWFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:05:04 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
X-Fcc: ~/Mail/utrace
Cc: Christoph Hellwig <hch@infradead.org>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: Alan Stern's message of  Monday, 5 March 2007 11:16:48 -0500 <Pine.LNX.4.44L0.0703051113350.3401-100000@iolanthe.rowland.org>
Emacs: the answer to the world surplus of CPU cycles.
Message-Id: <20070305220458.F0EC81800E5@magilla.sf.frob.com>
Date: Mon,  5 Mar 2007 14:04:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Please not.  That might save a few bytes, but it makes the interface a
> > lot harder to understand for users.  We really discourage over-loaded
> > interfaces in Linux.
> 
> I agree with Christoph.  Plenty of other interfaces in the kernel do the 
> same thing.

I don't think a single hook for both "on" and "off" notification is harder
to understand at all, it's natural.  But this is a very tiny point.

> I'll be happy to rename the structures and the files if Roland doesn't 
> mind.

I didn't much like "debugpoint" but I'm not wedded to vowellessness.
hw_breakpoint is fine by me.


Thanks,
Roland
