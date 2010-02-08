Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab0BHOlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 09:41:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474Ab0BHOlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 09:41:52 -0500
Message-ID: <4B70229D.4080603@redhat.com>
Date: Mon, 08 Feb 2010 16:41:33 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, KVM list <kvm@vger.kernel.org>,
       Adam Litke <agl@us.ibm.com>
Subject: Re: KVM in -next is somewhat busted
References: <20100208142752.2e859b7d@lxorguk.ukuu.org.uk>
In-Reply-To: <20100208142752.2e859b7d@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(fixed kvm@ address)


On 02/08/2010 04:27 PM, Alan Cox wrote:
> Reliably at boot time with todays -next I get the following:
>
> BUG: unable to handle kernel paging request at 0000000000001028
> IP: [<ffffffffa001c4c4>] balloon+0x1a1/0x309 [virtio_balloon]
> PGD 2cd42067 PUD 3b9dc067 PMD 0
> Oops: 0000 [#1] SMP
> last sysfs file: /sys/devices/virtio-pci/virtio4/block/vdd/removable
> CPU 3
> Pid: 511, comm: vballoon Not tainted 2.6.33-rc7-next-20100208+ #51 /
> RIP: 0010:[<ffffffffa001c4c4>]  [<ffffffffa001c4c4>] balloon+0x1a1/0x309 [virtio_balloon]
>    

Looks like the guest is broken, not the host.  Do things work if you 
leave out CONFIG_VIRTIO_BALLOON?

Copying Adam Litke, who's name is on the latest balloon changes.

-- 
error compiling committee.c: too many arguments to function

