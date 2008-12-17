Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759449AbYLQHWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449AbYLQHWS (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 02:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbYLQHV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 02:21:58 -0500
Received: from kroah.org ([198.145.64.141]:58899 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752308AbYLQHV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 02:21:56 -0500
Date: Tue, 16 Dec 2008 23:21:05 -0800
From: Greg KH <greg@kroah.com>
To: "Zhao, Yu" <yu.zhao@intel.com>
Cc: Jike Song <albcamus@gmail.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "achiang@hp.com" <achiang@hp.com>,
        "bjorn.helgaas@hp.com" <bjorn.helgaas@hp.com>,
        "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "matthew@wil.cx" <matthew@wil.cx>,
        "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "rdreier@cisco.com" <rdreier@cisco.com>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
Message-ID: <20081217072105.GA13408@kroah.com>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com> <200812161523.55238.jbarnes@virtuousgeek.org> <49486602.5000108@gmail.com> <20081217060608.GA12618@kroah.com> <4948A52B.7040403@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4948A52B.7040403@intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 03:07:23PM +0800, Zhao, Yu wrote:
> Greg KH wrote:
>> On Wed, Dec 17, 2008 at 10:37:54AM +0800, Jike Song wrote:
>>> Jesse Barnes wrote:
>>>> Given a respin of 10-13 I think it's reasonable to merge this into 
>>>> 2.6.29, but I'd be much happier about it if we got some driver code 
>>>> along with it, so as not to have an unused interface sitting around for 
>>>> who knows how many releases.  Is that reasonable?  Do you know if any of 
>>>> the corresponding PF/VF driver bits are ready yet?
>>> Hi Jesse, 
>>> Yu Zhao has posted a patch set with subject "SR-IOV driver example" at 
>>> November 26, which illustrated the usage of SR-IOV API in Intel 82576 
>>> VF/PF
>>> drivers;-)
>> Yes, but that driver was soundly rejected by the network driver
>> maintainers, so I wouldn't go around showing that as your primary
>> example of how to use this interface :)
>> The point is valid, I don't think these apis should go into the tree
>> without a driver or some other code using them.  Otherwise they make no
>> sense at all to have in-tree.
>
> I agree the point is valid, but on another hand this is a 'the chicken & 
> the egg' problem -- if we don't have the SR-IOV base, people who are 
> developing PF drivers can not get their changes in-tree. Maybe they are 
> holding the patches and waiting on the infrastructure... :-)

Are they?  They can both go in at the same time, like almost every other
api addition to the kernel, right?

thanks,

greg k-h
