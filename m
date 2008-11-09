Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYKIT2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYKIT2y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 14:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702AbYKIT2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 14:28:44 -0500
Received: from kroah.org ([198.145.64.141]:46456 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755652AbYKIT2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 14:28:43 -0500
Date: Sun, 9 Nov 2008 11:25:05 -0800
From: Greg KH <greg@kroah.com>
To: Avi Kivity <avi@redhat.com>
Cc: "Fischer, Anna" <anna.fischer@hp.com>, H L <swdevyid@yahoo.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "Chiang, Alexander" <achiang@hp.com>, "matthew@wil.cx" <matthew@wil.cx>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Message-ID: <20081109192505.GA3091@kroah.com>
References: <20081106154351.GA30459@kroah.com> <894107.30288.qm@web45108.mail.sp1.yahoo.com> <20081106164919.GA4099@kroah.com> <0199E0D51A61344794750DC57738F58E5E26F996C4@GVW1118EXC.americas.hpqcorp.net> <20081106180354.GA17429@kroah.com> <4916DB16.2040709@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4916DB16.2040709@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2008 at 02:44:06PM +0200, Avi Kivity wrote:
> Greg KH wrote:
>> It's that "second" part that I'm worried about.  How is that going to
>> happen?  Do you have any patches that show this kind of "assignment"?
>>
>>   
>
> For kvm, this is in 2.6.28-rc.

Where?  I just looked and couldn't find anything, but odds are I was
looking in the wrong place :(

> Note there are two ways to assign a device to a guest:
>
> - run the VF driver in the guest: this has the advantage of best 
> performance, but requires pinning all guest memory, makes live migration a 
> tricky proposition, and ties the guest to the underlying hardware.

Is this what you would prefer for kvm?

> - run the VF driver in the host, and use virtio to connect the guest to the 
> host: allows paging the guest and allows straightforward live migration, 
> but reduces performance, and hides any features not exposed by virtio from 
> the guest.

thanks,

greg k-h
