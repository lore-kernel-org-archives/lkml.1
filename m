Return-Path: <linux-kernel-owner+w=401wt.eu-S1757484AbYDGWEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484AbYDGWEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 18:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbYDGWEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 18:04:41 -0400
Received: from styx.suse.cz ([82.119.242.94]:58307 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752758AbYDGWEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 18:04:41 -0400
Date: Tue, 8 Apr 2008 00:04:39 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: using smp_processor_id() during suspend with 2.6.25-rc8
In-Reply-To: <87abk5qq6u.fsf@basil.nowhere.org>
Message-ID: <Pine.LNX.4.64.0804080003340.3896@jikos.suse.cz>
References: <c4e36d110804070625n17eb44e1nbb5558f500f13438@mail.gmail.com>
 <Pine.LNX.4.64.0804072348050.26562@twin.jikos.cz> <87abk5qq6u.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2008, Andi Kleen wrote:

> > It is not safe to call smp_processor_id() in cases we are not sure 
> > someone will not reschedule us.
> We are sure. Machine checks always run with interrupts off.

I know. However preempt_count is a little bit inconsistent in such cases 
though.

-- 
Jiri Kosina
