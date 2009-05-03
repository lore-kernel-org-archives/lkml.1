Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbZECT0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbZECT0X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 15:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755352AbZECT0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 15:26:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41241 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755108AbZECT0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 15:26:07 -0400
Date: Sun, 3 May 2009 22:25:07 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [KVM PATCH v3 2/2] kvm: add support for irqfd via
	eventfd-notification interface
Message-ID: <20090503192507.GA15780@redhat.com>
References: <20090427182540.6646.96740.stgit@dev.haskins.net> <20090427183334.6646.90800.stgit@dev.haskins.net> <20090430130708.GA13763@redhat.com> <49FDCD7C.7070605@redhat.com> <20090503190427.GB14483@redhat.com> <49FDEDBC.2090306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FDEDBC.2090306@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 10:17:16PM +0300, Avi Kivity wrote:
>> Actually there's a third option: add KVM_MASK_IRQ, KVM_UNMASK_IRQ ioctls
>> which will block/unblock guest from getting interrupt on this irq,
>> whatever the source.  Interrupts are queued in kernel while masked. A
>> third ioctl KVM_PENDING_IRQS will return the status for a set if IRQs.
>> qemu would call these ioctls when guest edits the MSIX vector control or
>> reads the pending bit array.
>>   
>
> I think this is the best option.

Sounds good.

-- 
MST
