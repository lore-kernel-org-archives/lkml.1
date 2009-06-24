Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbZFXIti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbZFXIti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 04:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbZFXIt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 04:49:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36621 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbZFXIt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 04:49:28 -0400
Date: Wed, 24 Jun 2009 11:49:01 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH] kvm: remove in_range from kvm_io_device
Message-ID: <20090624084901.GB22865@redhat.com>
References: <20090623150008.GA21059@redhat.com> <4A4184C3.6060503@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4184C3.6060503@novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 09:43:31PM -0400, Gregory Haskins wrote:
> Michael S. Tsirkin wrote:
> > Remove in_range from kvm_io_device and ask read/write callbacks, if
> > supplied, to perform range checks internally. This allows aliasing
> > (mostly for in-kernel virtio), as well as better error handling by
> > making it possible to pass errors up to userspace. And it's enough to
> > look at the diffstat to see that it's a better API anyway.
> >
> > While we are at it, document locking rules for kvm_io_device.
> >   
> 
> Hi Michael,
> 
> I just tried to apply this to kvm.git/master, and it blew up really
> badly.  What tree should I be using?

Ugh, this is against 2.6.30. I'll post kvm.git version soon.

