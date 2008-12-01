Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbYLAMmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbYLAMmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbYLAMmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:42:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:9635 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbYLAMmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:42:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,695,1220252400"; 
   d="scan'208";a="366672194"
Date: Tue, 2 Dec 2008 00:46:22 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Greg KH <greg@kroah.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [SR-IOV driver example 2/3] PF driver: integrate with SR-IOV
	core
Message-ID: <20081201164622.GC1464@yzhao12-linux.sh.intel.com>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com> <20081126140303.GA13641@yzhao12-linux.sh.intel.com> <20081126142156.GB13668@yzhao12-linux.sh.intel.com> <20081126165859.GA28251@kroah.com> <20081126175427.GE19881@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126175427.GE19881@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 01:54:27AM +0800, Chris Wright wrote:
> * Greg KH (greg@kroah.com) wrote:
> > > +static	int
> > > +igb_virtual(struct pci_dev *pdev, int nr_virtfn)
> > > +{
> > > +	unsigned char my_mac_addr[6] = {0x00, 0xDE, 0xAD, 0xBE, 0xEF, 0xFF};
> > > +	struct net_device *netdev = pci_get_drvdata(pdev);
> > > +	struct igb_adapter *adapter = netdev_priv(netdev);
> > > +	int i;
> > > +
> > > +	if (nr_virtfn > 7)
> > > +		return -EINVAL;
> > 
> > Why the check for 7?  Is that the max virtual functions for this card?
> > Shouldn't that be a define somewhere so it's easier to fix in future
> > versions of this hardware?  :)
> 
> IIRC it's 8 for the card, 1 reserved for PF.  I think both notions
> should be captured w/ commented constants.

You remember correctly! I'll put some comments there as suggested.

Thanks,
Yu
