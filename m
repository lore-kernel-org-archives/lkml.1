Return-Path: <linux-kernel-owner+w=401wt.eu-S1161027AbXBVLmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161027AbXBVLmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 06:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161042AbXBVLmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 06:42:47 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:36232 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161027AbXBVLmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 06:42:46 -0500
Date: Thu, 22 Feb 2007 17:13:26 +0530
From: "S. P. Prasanna" <prasanna@in.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Roland McGrath <roland@redhat.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Kwatch: kernel watchpoints using CPU debug registers
Message-ID: <20070222114326.GA14910@in.ibm.com>
Reply-To: prasanna@in.ibm.com
References: <20070209233150.B9542180055@magilla.sf.frob.com> <Pine.LNX.4.44L0.0702211458250.3435-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0702211458250.3435-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 03:35:13PM -0500, Alan Stern wrote:
> Going back to something you mentioned earlier...
> 
[...]
> On Fri, 9 Feb 2007, Roland McGrath wrote:
> There are two things I am uncertain about: vm86 mode and kprobes.  I don't
> know anything about how either of them works.  Judging from the current
> code, nothing much should be needed -- debug traps in vm86 mode are
> handled by calling handle_vm86_trap(), and kprobes puts itself at the
> start of the notify_die() chain so it can handle single-step traps.  
> Eventually it will be necessary to check with someone who really 
> understands the issues.

Yes, Kprobes needs to get notified first to handle single-step traps. So kwatch
getting notified secound should be fine.

Thanks
Prasanna
-- 
Prasanna S.P.
Linux Technology Center
India Software Labs, IBM Bangalore
Email: prasanna@in.ibm.com
Ph: 91-80-41776329
