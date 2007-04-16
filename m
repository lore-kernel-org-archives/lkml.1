Return-Path: <linux-kernel-owner+w=401wt.eu-S1752812AbXDPOvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbXDPOvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 10:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbXDPOvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 10:51:38 -0400
Received: from server225-han.de-nserver.de ([85.158.176.91]:33041 "EHLO
	server225-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752812AbXDPOvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 10:51:38 -0400
Message-ID: <46238D75.4010409@codemercs.com>
Date: Mon, 16 Apr 2007 16:51:33 +0200
From: Robert Marquardt <marquardt@codemercs.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <htejun@gmail.com>,
       Markus Rechberger <markus.rechberger@amd.com>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] How should an exit routine wait for release()
 callbacks?
References: <Pine.LNX.4.44L0.0704161028330.4861-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0704161028330.4861-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by marquardt@codemercs.com through 87.187.10.176
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:

> On the other hand, this proposal involves adding a fair amount of overhead
> (all those .owner fields) for a rather small benefit.  And it involves
> modifying a core kernel subsystem (kernel/module.c).  All to prevent
> certain unlikely sorts of errors when removing a module -- something which
> Linus has said repeatedly need not be supported terribly well.
> 
> So I'm uncertain whether other people will be in favor of all this.

I think Linus is in error here. Either do it right or not at all. I 
would say that modules should work *always* and without any conceptual 
problem.
