Return-Path: <linux-kernel-owner+w=401wt.eu-S1758467AbXHHJdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467AbXHHJdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 05:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932349AbXHHJdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 05:33:24 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59657 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932363AbXHHJdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 05:33:23 -0400
Date: Wed, 8 Aug 2007 15:03:36 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Haren Myneni <hbabu@us.ibm.com>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PATCH/RFC: [kdump] fix APIC shutdown sequence
Message-ID: <20070808093336.GB13808@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <46B73955.2080007@fujitsu-siemens.com> <20070807142928.GA18839@in.ibm.com> <46B8AECA.7050908@fujitsu-siemens.com> <m1ir7qg7kd.fsf@ebiederm.dsl.xmission.com> <46B986D5.2010407@fujitsu-siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B986D5.2010407@fujitsu-siemens.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 11:03:17AM +0200, Martin Wilck wrote:
> Hello Eric,
> 
> > How bad is it if you just run with irqpoll in the kdump kernel?
> > If running with irqpoll is usable that is probably preferable
> > to putting in a hardware work around we can survive without.
> 
> Yes, I tried that. No effect.
> 

Martin, at least irpoll should have worked. I am assuming your timer
interrupts are coming in second kernel. In that case we are not
dependent at all on actually receiving device interrupt. Polling should
take care of it.

What is that device which is not working? What is the success criterion?
I mean, did you check that the irq handler of your driver is now invoked
with irqpoll and now it can drive the device without worrying about
LAPIC and IOAPIC settings?

Thanks
Vivek
