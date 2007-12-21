Return-Path: <linux-kernel-owner+w=401wt.eu-S1759995AbXLUAPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995AbXLUAPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 19:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbXLUAPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 19:15:34 -0500
Received: from ns2.suse.de ([195.135.220.15]:36582 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbXLUAPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 19:15:34 -0500
Date: Thu, 20 Dec 2007 16:14:25 -0800
From: Greg KH <gregkh@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: patch
	pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
	added to gregkh-2.6 tree
Message-ID: <20071221001425.GB23322@suse.de>
References: <11981938363358@kroah.org> <1198194973.6779.35.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198194973.6779.35.camel@pasglop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2007 at 10:56:13AM +1100, Benjamin Herrenschmidt wrote:
> 
> > The current pci_assign_unassigned_resources() code doesn't work properly
> > on 32 bits platforms with 64 bits resources. The main reason is the use
> > of unsigned long in various places instead of resource_size_t.
> > 
> > This fixes it, along with some tricks to avoid casting to 64 bits on
> > platforms that don't need it in every printk around.
> 
> Can you still edit the changelog ?

Yes I can.

> If yes, please remove that sentence
> since the latest version (which you put in your tree) doesn't actually
> have those tricks anymore as per discussion on the list...

Ok, now done, thanks.

greg k-h
