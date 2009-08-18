Return-Path: <linux-kernel-owner+w=401wt.eu-S1757982AbZHRI4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982AbZHRI4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 04:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbZHRIz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 04:55:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60030 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615AbZHRIz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 04:55:58 -0400
Date: Tue, 18 Aug 2009 11:54:09 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Gregory Haskins <gregory.haskins@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       Avi Kivity <avi@redhat.com>, alacrityvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/6] vbus: add a "vbus-proxy" bus model for
	vbus_driver objects
Message-ID: <20090818085409.GB13878@redhat.com>
References: <20090814154125.26116.70709.stgit@dev.haskins.net> <20090814154308.26116.46980.stgit@dev.haskins.net> <20090815103243.GA26749@elte.hu> <4A870964.9090408@codemonkey.ws> <4A8965E0.8050608@gmail.com> <4A89FF08.30509@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A89FF08.30509@codemonkey.ws>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 08:08:24PM -0500, Anthony Liguori wrote:
> In particular, I think it would be a big win to avoid knowledge of slots in  
> the kernel by doing ring translation in userspace.

vhost supports this BTW: just don't call the memory table ioctl.
In-kernel translation is simple, as well, though.

-- 
MST
