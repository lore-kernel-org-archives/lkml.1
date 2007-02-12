Return-Path: <linux-kernel-owner+w=401wt.eu-S933068AbXBLHcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbXBLHcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:32:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933069AbXBLHcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:32:09 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:20589
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933068AbXBLHcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:32:08 -0500
Message-Id: <45D025BF.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Mon, 12 Feb 2007 07:30:55 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Christoph Hellwig" <hch@lst.de>
Cc: <tony.luck@intel.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [IA64] swiotlb abstraction (e.g. for Xen)
References: <200702070759.l177xIti030295@hera.kernel.org>
 <20070207083254.GA24561@lst.de> <20070211072555.GA22831@lst.de>
In-Reply-To: <20070211072555.GA22831@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 07, 2007 at 09:32:54AM +0100, Christoph Hellwig wrote:
> On Wed, Feb 07, 2007 at 07:59:18AM +0000, Linux Kernel Mailing List wrote:
> >     [IA64] swiotlb abstraction (e.g. for Xen)
> >     
> >     Add abstraction so that the file can be used by environments other than IA64
> >     and EM64T, namely for Xen.
> 
> Tony, this code is more than ugly, and even further not needed for anything
> we actually need.  Can you please revert it.
> 
> Some comments below in case we need justification..
> 
> If Jan actually had a goal with that except making the code utterly
> unreadable he should try again with small patches that are well
> explained and do one thing at a at time.  (And cane be reviewed an
> improved on if needed.

As the topic says - the goal is to support Xen. But yes, I was afraid someone would
claim this make the code look ugly. And no, I currently don't have ideas to address
any of your comments without breaking functionality on Xen...

Jan
