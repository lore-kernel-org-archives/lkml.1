Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367AbZHLTWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbZHLTWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 15:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbZHLTWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 15:22:42 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:21131 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZHLTWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 15:22:41 -0400
Message-ID: <4A83167E.2080701@codemonkey.ws>
Date: Wed, 12 Aug 2009 14:22:38 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Arnd Bergmann <arnd@arndb.de>, virtualization@lists.linux-foundation.org,
       "Ira W. Snyder" <iws@ovro.caltech.edu>, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vhost_net: a kernel-level virtio server
References: <cover.1249930169.git.mst@redhat.com> <20090810185340.GC13924@redhat.com> <200908121903.22325.arnd@arndb.de> <20090812172141.GA29966@redhat.com>
In-Reply-To: <20090812172141.GA29966@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin wrote:
>>
>> We discussed this before, and I still think this could be directly derived
>> from struct virtqueue, in the same way that vring_virtqueue is derived from
>> struct virtqueue.
>>     
>
> I prefer keeping it simple. Much of abstraction in virtio is due to the
> fact that it needs to work on top of different hardware emulations:
> lguest,kvm, possibly others in the future.  vhost is always working on
> real hardware, using eventfd as the interface, so it does not need that.
>   

Actually, vhost may not always be limited to real hardware.

We may on day use vhost as the basis of a driver domain.  There's quite 
a lot of interest in this for networking.

At any rate, I'd like to see performance results before we consider 
trying to reuse virtio code.

Regards,

Anthony Liguori
