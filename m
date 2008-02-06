Return-Path: <linux-kernel-owner+w=401wt.eu-S1753192AbYBFOV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbYBFOV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 09:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbYBFOVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 09:21:19 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:52667 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbYBFOVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 09:21:18 -0500
Message-ID: <47A9C24E.7020004@garzik.org>
Date: Wed, 06 Feb 2008 09:21:02 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Bart Van Assche <bart.vanassche@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Vladislav Bolkhovitin <vst@vlnb.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Integration of SCST in the mainstream Linux kernel
References: <47A05CBD.5050803@vlnb.net>	 <1202145901.3096.49.camel@localhost.localdomain>	 <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>	 <1202151989.11265.576.camel@haakon2.linux-iscsi.org>	 <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>	 <20080204210121.GF18682@fieldses.org>	 <alpine.LFD.1.00.0802041317280.3034@hp.linux-foundation.org>	 <47A7986B.1070206@garzik.org>	 <e2e108260802050038v6648495ap13cf799727c00cfc@mail.gmail.com>	 <47A8A1C8.2010407@garzik.org> <e2e108260802060222p294abff9kde72bbb04a115752@mail.gmail.com>
In-Reply-To: <e2e108260802060222p294abff9kde72bbb04a115752@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche wrote:
> On Feb 5, 2008 6:50 PM, Jeff Garzik <jeff@garzik.org> wrote:
>> For remotely accessing data, iSCSI+fs is quite simply more overhead than
>> a networked fs.  With iSCSI you are doing
>>
>>         local VFS -> local blkdev -> network
>>
>> whereas a networked filesystem is
>>
>>         local VFS -> network
> 
> There are use cases than can be solved better via iSCSI and a
> filesystem than via a network filesystem. One such use case is when
> deploying a virtual machine whose data is stored on a network server:
> in that case there is only one user of the data (so there are no
> locking issues) and filesystem and block device each run in another
> operating system: the filesystem runs inside the virtual machine and
> iSCSI either runs in the hypervisor or in the native OS.

Hence the diskless root fs configuration I referred to in multiple 
emails...  whoopee, you reinvented NFS root with quotas :)

	Jeff



