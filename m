Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbXLLQSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbXLLQSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 11:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbXLLQSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 11:18:00 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54036 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbXLLQR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 11:17:59 -0500
Date: Wed, 12 Dec 2007 17:17:58 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mark Lord <lkml@rtr.ca>
Cc: Anas Nashif <nashif@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Intel Management Engine Interface
Message-ID: <20071212161758.GD21864@one.firstfloor.org>
References: <475EC9C1.9080708@linux.intel.com> <p7363z5nlo8.fsf@bingen.suse.de> <475ED912.609@linux.intel.com> <20071211185317.GA21864@one.firstfloor.org> <475EDFA3.1070001@linux.intel.com> <475FF788.5000906@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475FF788.5000906@rtr.ca>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 10:00:24AM -0500, Mark Lord wrote:
> Anas Nashif wrote:
> >
> >Actually no TCP/IP is needed here. Basically the MEI driver writes and 
> >reads the
> >messages to/from the firmware. When communicating in-band using LMS, TCP/IP
> >terminates at LMS and the messages are copied using MEI driver.
> >
> >>>To have a feel for all of this, with many examples, samples and 
> >>>documentation
> >>>you can download the AMT 3.0 SDK (google: intel amt sdk).
> >>I would be more interested right now how the kernel can use this without
> >>additional user space support. Any ideas on this? 
> >
> >I will dig for some documents on that.
> ..
> 
> Sample code for storing a trace_back() would be much better.

Better just a patch that handles all oopses or perhaps better
all printk output (meconsole?) 

-Andi
