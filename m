Return-Path: <linux-kernel-owner+w=401wt.eu-S1751790AbYKGUNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbYKGUNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 15:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYKGUNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 15:13:00 -0500
Received: from kroah.org ([198.145.64.141]:57317 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752815AbYKGUMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 15:12:55 -0500
Date: Fri, 7 Nov 2008 10:53:25 -0800
From: Greg KH <greg@kroah.com>
To: "Zhao, Yu" <yu.zhao@intel.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "achiang@hp.com" <achiang@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 16/16 v6] PCI: document the new PCI boot parameters
Message-ID: <20081107185325.GE2320@kroah.com>
References: <20081106043235.GA30292@kroah.com> <4913AA03.5060807@intel.com> <20081107025032.GA12824@kroah.com> <4913B8A5.5010806@intel.com> <20081107061603.GC3860@kroah.com> <4913F34A.8020805@intel.com> <20081107080222.GA6284@kroah.com> <4913F97E.7030408@intel.com> <20081107082432.GA6601@kroah.com> <4913FDE3.8050804@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4913FDE3.8050804@intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 04:35:47PM +0800, Zhao, Yu wrote:
> Greg KH wrote:
>> On Fri, Nov 07, 2008 at 04:17:02PM +0800, Zhao, Yu wrote:
>>>> Well, to do it "correctly" you are going to have to tell the driver to
>>>> shut itself down, and reinitialize itself.
>>>> Turns out, that doesn't really work for disk and network devices without
>>>> dropping the connection (well, network devices should be fine probably).
>>>> So you just can't do this, sorry.  That's why the BIOS handles all of
>>>> these issues in a PCI hotplug system.
>>>> How does the hardware people think we are going to handle this in the
>>>> OS?  It's not something that any operating system can do, is it part of
>>>> the IOV PCI spec somewhere?
>>> No, it's not part of the PCI IOV spec.
>>>
>>> I just want the IOV (and whole PCI subsystem) have more flexibility on 
>>> various BIOSes. So can we reconsider about resource rebalance as boot 
>>> option, or should we forget about this idea?
>> As you have proposed it, the boot option will not work at all, so I
>> think we need to forget about it.  Especially if it is not really
>> needed.
>
> I guess at least one thing would work if people don't want to boot twice: 
> give the bus number 0 as rebalance starting point, then all system 
> resources would be reshuffled :-)

Hm, but don't we do that today with our basic resource reservation logic
at boot time?  What would be different about this kind of proposal?

thanks,

greg k-h
