Return-Path: <linux-kernel-owner+w=401wt.eu-S1030512AbXCFWyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030512AbXCFWyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 17:54:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030506AbXCFWyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 17:54:10 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34670 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932510AbXCFWyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 17:54:08 -0500
Date: Tue, 6 Mar 2007 14:52:41 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: David Miller <davem@davemloft.net>, jeremy@goop.org, ak@muc.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       chrisw@sous-sol.org, zach@vmware.com, rusty@rustcorp.com.au,
       ian.pratt@xensource.com, Christian.Limpach@cl.cam.ac.uk,
       netdev@vger.kernel.org, jeff@garzik.org
Subject: Re: [RFC] ARP notify option
Message-ID: <20070306145241.5ec1c511@freekitty>
In-Reply-To: <45EDDA8F.5060106@nortel.com>
References: <20070301164214.4a40bc59@freekitty>
	<45E7764A.7000100@goop.org>
	<20070301173030.754514ec@freekitty>
	<20070305.203536.92584097.davem@davemloft.net>
	<20070306105132.52c77491@freekitty>
	<45EDDA8F.5060106@nortel.com>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Mar 2007 15:18:07 -0600
"Chris Friesen" <cfriesen@nortel.com> wrote:

> Stephen Hemminger wrote:
> 
> > +arp_notify - BOOLEAN
> > +	Define mode for notification of address and device changes.
> > +	0 - (default): do nothing
> > +	1 - Generate gratuitous arp replies when device is brought up
> > +	    or hardware address changes.
> 
> Did you consider using gratuitous arp requests instead?  I remember 
> reading about some hardware that updated its arp cache on gratuitous 
> requests but not gratuitous replies.
> 
> Chris

I copied the ARP generation from other places that were doing
gratuitous ARP already:  Xen and irlan.
Our local switch used REPLY's to do the same thing.

One could imagine making it a ternary value and having 2 generate
REQUEST's.


-- 
Stephen Hemminger <shemminger@linux-foundation.org>
