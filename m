Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbZIVKlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbZIVKlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 06:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbZIVKlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 06:41:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755928AbZIVKlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 06:41:04 -0400
Date: Tue, 22 Sep 2009 13:38:07 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       virtualization@lists.linux-foundation.org,
       "Xin, Xiaohui" <xiaohui.xin@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hpa@zytor.com" <hpa@zytor.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [RFC] Virtual Machine Device Queues(VMDq) support on KVM
Message-ID: <20090922103807.GA2555@redhat.com>
References: <C85CEDA13AB1CF4D9D597824A86D2B9006AEB94861@PDSMSX501.ccr.corp.intel.com> <20090901090518.1193e412@nehalam> <200909211637.23299.rusty@rustcorp.com.au> <20090921092130.30984dbd@s6510> <20090921162718.GM26034@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921162718.GM26034@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 09:27:18AM -0700, Chris Wright wrote:
> * Stephen Hemminger (shemminger@vyatta.com) wrote:
> > On Mon, 21 Sep 2009 16:37:22 +0930
> > Rusty Russell <rusty@rustcorp.com.au> wrote:
> > 
> > > > > Actually this framework can apply to traditional network adapters which have
> > > > > just one tx/rx queue pair. And applications using the same user/kernel interface
> > > > > can utilize this framework to send/receive network traffic directly thru a tx/rx
> > > > > queue pair in a network adapter.
> > > > > 
> > 
> > More importantly, when virtualizations is used with multi-queue
> > NIC's the virtio-net NIC is a single CPU bottleneck. The virtio-net
> > NIC should preserve the parallelism (lock free) using multiple
> > receive/transmit queues. The number of queues should equal the
> > number of CPUs.
> 
> Yup, multiqueue virtio is on todo list ;-)
> 
> thanks,
> -chris

Note we'll need multiqueue tap for that to help.

-- 
MST
