Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab0CGLLa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 06:11:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51490 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078Ab0CGLL3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 06:11:29 -0500
Subject: Re: [PULL] virtio
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20100307110457.GB20004@redhat.com>
Date: Sun, 7 Mar 2010 12:11:26 +0100
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Adam Litke <agl@us.ibm.com>, Amit Shah <amit.shah@redhat.com>,
       hch@lst.de, Jamie Lokier <jamie@shareable.org>,
       Shirley Ma <mashirle@us.ibm.com>,
       Anthony Liguori <aliguori@linux.vnet.ibm.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <E836C482-083B-4030-9BF2-818FB3647B4D@suse.de>
References: <20100307104252.GA19926@redhat.com> <40B76F19-1E35-4956-A34E-0A83A403F97D@suse.de> <20100307110457.GB20004@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 07.03.2010, at 12:04, Michael S. Tsirkin wrote:

> On Sun, Mar 07, 2010 at 11:57:23AM +0100, Alexander Graf wrote:
>> 
>> On 07.03.2010, at 11:42, Michael S. Tsirkin wrote:
>> 
>>> Linus,
>>> Please pull another virtio fix: this one fixes hotplug and
>>> was supposed to be applied by Rusty already
>>> (http://lkml.org/lkml/2009/11/30/451), but apparently got lost,
>>> somehow.
>>> 
>>> Thanks!
>>> 
>>> The following changes since commit 3119815912a220bdac943dfbdfee640414c0c611:
>>> Michael S. Tsirkin (1):
>>>       virtio: fix out of range array access
>>> 
>>> are available in the git repository at:
>>> 
>>> git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git for-linus
>>> 
>>> Michael S. Tsirkin (1):
>>>     virtio: set pci bus master enable bit
>> 
>> This is still missing an identifier for the hypervisor. We need to know if the guest will ever set bus master enabled or not, so we can have a compat hack in qemu to not check for it.
>> 
>> 
>> Alex
> 
> This patch fixes hotplug with qemu 0.11-0.12 which can't make use of a new
> identifier without a time machine.

For 0.12 there's -stable and I don't think the bad patch is in 0.11 yet?

> IMHO we can't add new identifiers in time for 2.6.34 anyway, so if you
> want to do that, please send a patch and have it queued up for the next
> release. But I don't think we need an identifier for compat hack.
> Hypervisor can detect buggy guests when they set status to OK without
> enabling bus master first.
> 
> Makes sense?

Ah, so you'd do the compat hack purely in qemu? Sounds good to me.

Nevermind the noise - please take that patch :-).

Alex