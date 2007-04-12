Return-Path: <linux-kernel-owner+w=401wt.eu-S1030649AbXDLR7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030649AbXDLR7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 13:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030651AbXDLR7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 13:59:11 -0400
Received: from canuck.infradead.org ([209.217.80.40]:42686 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030649AbXDLR7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 13:59:09 -0400
Date: Thu, 12 Apr 2007 10:58:26 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Helge Hafting <helgehaf@aitel.hist.no>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, Corey Minyard <minyard@acm.org>,
       Mike Galbraith <efault@gmx.de>, Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang
Message-ID: <20070412175826.GA4734@kroah.com>
References: <20070408143559.f5014629.akpm@linux-foundation.org> <20070411194227.GA31286@aitel.hist.no> <20070411134346.d10765da.akpm@linux-foundation.org> <20070411230700.GA4023@aitel.hist.no> <Pine.LNX.4.64.0704120947230.12991@twin.jikos.cz> <Pine.LNX.4.64.0704121001400.12991@twin.jikos.cz> <Pine.LNX.4.64.0704121642110.12991@twin.jikos.cz> <20070412095531.d792f671.akpm@linux-foundation.org> <Pine.LNX.4.64.0704121937310.12991@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704121937310.12991@twin.jikos.cz>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 07:49:02PM +0200, Jiri Kosina wrote:
> On Thu, 12 Apr 2007, Andrew Morton wrote:
> 
> > Was that with ipmi linked into vmlinux?  (Please send the output of grep 
> > IPMI .config) I thought we fixed that.
> 
> Confirmed. 2.6.21-rc6-mm1 with
> 
> CONFIG_IPMI_SI=y
> 
> hangs upon boot on the already mentioned printk from ipmi_si. With
> 
> CONFIG_IPMI_SI=m
> 
> the boot succeeds. When manually trying to modprobe ipmi_si after that, 
> the modprobe itself hangs, but the machine remains usable otherwise.
> 
> I still wonder if this could be related to what Helge was originally 
> reporting.

Does this same .config hang in 2.6.21-rc6 without the -mm stuff?

thanks,

greg k-h
