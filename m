Return-Path: <linux-kernel-owner+w=401wt.eu-S1757401AbYDGWH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbYDGWH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 18:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbYDGWHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 18:07:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53988 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbYDGWHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 18:07:50 -0400
Date: Tue, 8 Apr 2008 00:12:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: using smp_processor_id() during suspend with 2.6.25-rc8
Message-ID: <20080407221210.GF16647@one.firstfloor.org>
References: <c4e36d110804070625n17eb44e1nbb5558f500f13438@mail.gmail.com> <Pine.LNX.4.64.0804072348050.26562@twin.jikos.cz> <87abk5qq6u.fsf@basil.nowhere.org> <Pine.LNX.4.64.0804080003340.3896@jikos.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804080003340.3896@jikos.suse.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2008 at 12:04:39AM +0200, Jiri Kosina wrote:
> On Tue, 8 Apr 2008, Andi Kleen wrote:
> 
> > > It is not safe to call smp_processor_id() in cases we are not sure 
> > > someone will not reschedule us.
> > We are sure. Machine checks always run with interrupts off.
> 
> I know. However preempt_count is a little bit inconsistent in such cases 
> though.

And? interrupts off beats preempt count anyways.

Why did you write the patch? Was there a (incorrect) warning triggered?

-Andi
