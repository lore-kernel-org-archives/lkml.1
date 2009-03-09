Return-Path: <linux-kernel-owner+w=401wt.eu-S1752787AbZCIAsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbZCIAsX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 20:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZCIAsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 20:48:10 -0400
Received: from kroah.org ([198.145.64.141]:43473 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752138AbZCIAsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 20:48:09 -0400
Date: Sun, 8 Mar 2009 17:45:47 -0700
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Avi Kivity <avi@redhat.com>, Yu Zhao <yu.zhao@intel.com>,
       jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Yang, Sheng" <sheng.yang@intel.com>
Subject: Re: [PATCH v10 0/7] PCI: Linux kernel SR-IOV support
Message-ID: <20090309004547.GB4062@kroah.com>
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <49A3D04A.9010501@redhat.com> <20090306193329.GB25995@parisc-linux.org> <49B3D678.4050004@redhat.com> <20090308150109.GM25995@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090308150109.GM25995@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 08, 2009 at 09:01:09AM -0600, Matthew Wilcox wrote:
> On Sun, Mar 08, 2009 at 04:30:16PM +0200, Avi Kivity wrote:
> > Matthew Wilcox wrote:
> > >On Tue, Feb 24, 2009 at 12:47:38PM +0200, Avi Kivity wrote:
> > >>Do those patches allow using a VF on the host (in other words, does the 
> > >>kernel emulate config space accesses)?
> > >
> > >SR-IOV hardware handles config space accesses to virtual functions.  No
> > >kernel changes needed for that aspect of it.
> > 
> > Patches 2 and 3 of the patchset that enables SR/IOV in kvm [1] suggest 
> > that at the config space is only partially implemented.
> > 
> > [1] http://thread.gmane.org/gmane.comp.emulators.kvm.devel/29034
> 
> I believe Red Hat are now members of the PCI SIG, you really should
> download the SR-IOV spec that Yu Zhao keeps pointing at.  It's going to
> be very hard to have a sensible discussion if you haven't read it.

But if any kernel developers are working for companies that are not
members of the PCI SIG, and wish to read the PCI specs, please let me
know as we are working to enable this to happen through the Linux
Foundation.

thanks,

greg k-h
