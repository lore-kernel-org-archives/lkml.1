Return-Path: <linux-kernel-owner+w=401wt.eu-S933683AbYETUBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933683AbYETUBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 16:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758693AbYETUBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 16:01:09 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:44231 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736AbYETUBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 16:01:07 -0400
Date: Tue, 20 May 2008 13:00:49 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Gary Hade <garyhade@us.ibm.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI: boot parameter to avoid expansion ROM memory allocation
Message-ID: <20080520200049.GA7334@us.ibm.com>
References: <20080512205746.GB7401@us.ibm.com> <20080514000702.GA12546@us.ibm.com> <20080514162015.GA6713@us.ibm.com> <200805201057.49679.jbarnes@virtuousgeek.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805201057.49679.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 10:57:49AM -0700, Jesse Barnes wrote:
> On Wednesday, May 14, 2008 9:20 am Gary Hade wrote:
> > > Correct, not a perfect solution but better than we have right now.
> >
> > ...but don't let this comment make you think that I am not in
> > favor of something like you are suggesting.  I am interested
> > in getting the 'pci=norom' change into mainline quickly but it
> > is obviously less than ideal for the long term.
> >
> > Jesse, any idea how many different devices absolutely need
> > memory allocated for their expansion ROMs?
> 
> Unless there's a ton of demand, I'd rather go with the norom option, but 
> either way, I'd like to push the fix early in the 2.6.27 cycle rather than 
> trying to get it into 2.6.26 at the last minute...

This is fine.  I would also like to see the pci=norom option
added as-is with the thought that we may improve later by either
modifying pci=norom to exclude devices that need memory mapped
to their expansion ROMs or by adding another option (pci=minrom ?)
that would do the same thing.

> 
> So assuming you're ok with your last patch, I'll stuff it into linux-next.

Works for me.  Thanks.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc
