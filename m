Return-Path: <linux-kernel-owner+w=401wt.eu-S1758211AbZIOV15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211AbZIOV15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 17:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbZIOV1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 17:27:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbZIOV1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 17:27:52 -0400
Date: Wed, 16 Sep 2009 00:25:45 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, "Ira W. Snyder" <iws@ovro.caltech.edu>,
       netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       Rusty Russell <rusty@rustcorp.com.au>, s.hetze@linux-ag.com,
       alacrityvm-devel@lists.sourceforge.net
Subject: Re: [PATCHv5 3/3] vhost_net: a kernel-level virtio server
Message-ID: <20090915212545.GC27954@redhat.com>
References: <20090914164750.GB3745@redhat.com> <4AAE961B.6020509@gmail.com> <4AAF8A03.5020806@redhat.com> <4AAF909F.9080306@gmail.com> <4AAF95D1.1080600@redhat.com> <4AAF9BAF.3030109@gmail.com> <4AAFACB5.9050808@redhat.com> <4AAFF437.7060100@gmail.com> <20090915204036.GA27954@redhat.com> <4AAFFC8E.9010404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAFFC8E.9010404@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 04:43:58PM -0400, Gregory Haskins wrote:
> Michael S. Tsirkin wrote:
> > On Tue, Sep 15, 2009 at 04:08:23PM -0400, Gregory Haskins wrote:
> >> No, what I mean is how do you surface multiple ethernet and consoles to
> >> the guests?  For Ira's case, I think he needs at minimum at least one of
> >> each, and he mentioned possibly having two unique ethernets at one point.
> >>
> >> His slave boards surface themselves as PCI devices to the x86
> >> host.  So how do you use that to make multiple vhost-based devices (say
> >> two virtio-nets, and a virtio-console) communicate across the transport?
> >>
> >> There are multiple ways to do this, but what I am saying is that
> >> whatever is conceived will start to look eerily like a vbus-connector,
> >> since this is one of its primary purposes ;)
> > 
> > Can't all this be in userspace?
> 
> Can you outline your proposal?
> 
> -Greg
> 

Userspace in x86 maps a PCI region, uses it for communication with ppc?

