Return-Path: <linux-kernel-owner+w=401wt.eu-S1759668AbYFDLNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759668AbYFDLNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 07:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbYFDLNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 07:13:15 -0400
Received: from styx.suse.cz ([82.119.242.94]:58538 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753100AbYFDLNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 07:13:14 -0400
Date: Wed, 4 Jun 2008 13:13:13 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, avi@qumranet.com
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 pm-suspend/17334
In-Reply-To: <alpine.LFD.1.10.0806041252540.3235@apollo.tec.linutronix.de>
Message-ID: <Pine.LNX.4.64.0806041312070.10085@jikos.suse.cz>
References: <c4e36d110806030142j379f5a63xfba7c3bbb9df602a@mail.gmail.com> 
 <Pine.LNX.4.64.0806031350330.1716@twin.jikos.cz>
 <c4e36d110806030501g46363beev7126c8312aadd12e@mail.gmail.com>
 <Pine.LNX.4.64.0806031402450.6718@jikos.suse.cz>
 <alpine.LFD.1.10.0806041252540.3235@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008, Thomas Gleixner wrote:

> > OK, so it looks like KVM could be wrongly enabling IRQs/preemption on 
> > the resume path. The original bug-report is on 
> > http://lkml.org/lkml/2008/4/7/130
> sysdev_resume() is supposed to run with interrupts disabled, at least
> it was that way when the timekeeping_resume code was written.

True. However in Zdenek's case, interrupts/preemption gets enabled 
somewhere during the resume, which correctly triggers the warning.

Thanks,

-- 
Jiri Kosina
SUSE Labs
