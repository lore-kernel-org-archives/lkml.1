Return-Path: <linux-kernel-owner+w=401wt.eu-S1764332AbYBBS4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764332AbYBBS4o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 13:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbYBBS4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 13:56:38 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37232 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbYBBS4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 13:56:37 -0500
Date: Sat, 2 Feb 2008 10:51:45 -0800
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: gregkh@suse.de, shaohua.li@intel.com, auke-jan.h.kok@intel.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       matthew@wil.cx, venkatesh.pallipadi@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bootup crash, -git] Re: patch pci-pcie-aspm-support.patch
	added to gregkh-2.6 tree
Message-ID: <20080202185145.GA13005@kroah.com>
References: <1201141317.26118.2.camel@sli10-desk.sh.intel.com> <12013009171835@kroah.org> <20080202105506.GA25160@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202105506.GA25160@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 11:55:06AM +0100, Ingo Molnar wrote:
> 
> * gregkh@suse.de <gregkh@suse.de> wrote:
> 
> > This is a note to let you know that I've just added the patch titled
> > 
> >      Subject: PCI: PCIE ASPM support
> > 
> > to my gregkh-2.6 tree.  Its filename is
> > 
> >      pci-pcie-aspm-support.patch
> 
> uhm. One week ago this patch was added to your PCI tree. It never 
> touched -mm AFAICS and today it was merged upstream (commit 
> 6c723d5bd89f03fc3ef627d50f89ade054d2ee3b):
> 
> Which is not necessarily a problem in itself, as long as you test it 
> through and are reasonably sure that it wont break systems en masse. But 
> this patch very evidently was not tested in any sufficient manner on its 
> primary platform (x86) because my randconfig testsystems (bog standard 
> x86 hw) started crashing during bootup almost immediately:

Ugh, this is causing just too many problems, I'm just going to revert
it.

Shaohua, care to look into this crash, fix up the config issues, and
resubmit it when it's working a bit better?

thanks,

greg k-h
