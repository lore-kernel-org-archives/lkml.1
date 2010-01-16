Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab0APAbi (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 19:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410Ab0APAbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 19:31:38 -0500
Received: from cantor.suse.de ([195.135.220.2]:41349 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab0APAbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 19:31:37 -0500
Date: Fri, 15 Jan 2010 16:15:25 -0800
From: Greg KH <gregkh@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org,
        Dave Airlie <airlied@redhat.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [Stable-review] [PATCH 15/52] drm: remove address mask param
 for drm_pci_alloc()
Message-ID: <20100116001521.GA7866@suse.de>
References: <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
 <1263508051-7868-11-git-send-email-gregkh@suse.de>
 <1263508051-7868-12-git-send-email-gregkh@suse.de>
 <1263508051-7868-13-git-send-email-gregkh@suse.de>
 <1263508051-7868-14-git-send-email-gregkh@suse.de>
 <1263508051-7868-15-git-send-email-gregkh@suse.de>
 <1263512328.17815.103.camel@localhost>
 <20100114234516.GA25061@suse.de>
 <20100115005606.GA3562@zhen-devel.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100115005606.GA3562@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 08:56:06AM +0800, Zhenyu Wang wrote:
> On 2010.01.14 15:45:16 -0800, Greg KH wrote:
> > On Thu, Jan 14, 2010 at 11:38:48PM +0000, Ben Hutchings wrote:
> > > On Thu, 2010-01-14 at 14:26 -0800, Greg Kroah-Hartman wrote:
> > > > From: Zhenyu Wang <zhenyu.z.wang@intel.com>
> > > > 
> > > > commit e6be8d9d17bd44061116f601fe2609b3ace7aa69 upstream.
> > > > 
> > > > drm_pci_alloc() has input of address mask for setting pci dma
> > > > mask on the device, which should be properly setup by drm driver.
> > > > And leave it as a param for drm_pci_alloc() would cause confusion
> > > > or mistake would corrupt the correct dma mask setting, as seen on
> > > > intel hw which set wrong dma mask for hw status page. So remove
> > > > it from drm_pci_alloc() function.
> > > 
> > > Based on comments at <http://bugs.freedesktop.org/show_bug.cgi?id=25510>
> > > I think we also need this fix:
> > > 
> > > commit fc61901373987ad61851ed001fe971f3ee8d96a3
> > > Author: David Woodhouse <dwmw2@infradead.org>
> > > Date:   Wed Dec 2 11:00:05 2009 +0000
> > > 
> > >     agp/intel-agp: Clear entire GTT on startup
> > > 
> > > Ben.
> > 
> > Ok, I can add that as well, if the Intel / DRM people do not object.
> > 
> > Anyone?
> > 
> 
> yeah, please add that one too, it's an important fix.

Ok, I've queued it up now.

thanks,

greg k-h
