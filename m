Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbYIJUHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbYIJUHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 16:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbYIJUHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 16:07:24 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:58563 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbYIJUHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 16:07:23 -0400
Date: Wed, 10 Sep 2008 14:07:21 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "Zhao, Yu" <yu.zhao@intel.com>
Cc: Roland Dreier <rdreier@cisco.com>, Alex Chiang <achiang@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, Greg KH <greg@kroah.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: Re: [PATCH 2/4 v2] PCI: support ARI capability
Message-ID: <20080910200721.GI2772@parisc-linux.org>
References: <ada3akjj268.fsf@cisco.com> <7A25B56E4BE99C4283EB931CD1A40E110181CAF7@pdsmsx414.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7A25B56E4BE99C4283EB931CD1A40E110181CAF7@pdsmsx414.ccr.corp.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 03:48:04PM +0800, Zhao, Yu wrote:
> >I agree with this improvement to the help text.  But a further question
> >is whether ARI even merits its own user-visible config option.  Is it
> >worth having yet another choice for users?  When would someone want ARI
> >but not SR-IOV?
> 
> ARI is an independent PCI Express extended capability. Multi-function devices supporting this capability may use it to track dependency between different functions and assign function group numbers to these functions.
> 
> Another reason to keep this separated with SR-IOV is that after ARI is enabled, PCI Express Endpoint may have non-zero slot number (device number), which is different from traditional PCI Express Endpoint.

Let me ask the question slightly differently: Why would someone want to
turn the capability off?  Is it just to save a few hundred bytes in the
kernel image, or is there some hardware that won't work?  Or some other
reason I haven't thought of?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
