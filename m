Return-Path: <linux-kernel-owner+w=401wt.eu-S1762706AbYAKWbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762706AbYAKWbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 17:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759994AbYAKWbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 17:31:39 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:46307 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757380AbYAKWbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 17:31:38 -0500
Date: Fri, 11 Jan 2008 23:30:25 +0100
From: Guillaume Chazarain <guichaz@yahoo.fr>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Dillow <dillowda@ornl.gov>, linux-kernel@vger.kernel.org,
       linux-btrace@vger.kernel.org, tglx@linutronix.de,
       Jens Axboe <jens.axboe@oracle.com>, nigel@suspend2.net
Subject: Re: CONFIG_NO_HZ breaks blktrace timestamps
Message-ID: <20080111233025.57d17f6a@inria.fr>
In-Reply-To: <20080111105534.GC1589@elte.hu>
References: <1199918912.8388.13.camel@lap75545.ornl.gov>
	<1199996752.9159.46.camel@lap75545.ornl.gov>
	<20080110234438.4826f658@inria.fr>
	<20080111114132.084036f2@cheypa.inria.fr>
	<20080111105534.GC1589@elte.hu>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:

> ok. I have applied all but this one

Hmm, I couldn't find them in mingo/linux-2.6-sched-devel.git.

> i think it's much simpler to do what i have below. Could you try it on 
> your box? Or if it is using ACPI idle - in that case the callbacks 
> should already be there and there should be no need for further fixups.
> 
> Subject: x86: idle wakeup event in the HLT loop

I use ACPI, so this patch has no effect.

FYI, I'm currently trying to track down where rq->clock started to
overflow with nohz=off, and it seems to be before 2.6.23, so my patches
are not at fault ;-) Or maybe I am dreaming and it was always
overflowing. Investigating ...

-- 
Guillaume
