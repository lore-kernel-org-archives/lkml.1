Return-Path: <linux-kernel-owner+w=401wt.eu-S1760056AbZCXM2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056AbZCXM2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757913AbZCXM1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:27:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53517 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbZCXM1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:27:54 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	<49C87B87.4020108@krogh.cc>
	<72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
	<20090324091545.758d00f5@lxorguk.ukuu.org.uk>
	<20090324093245.GA22483@elte.hu>
	<20090324101011.6555a0b9@lxorguk.ukuu.org.uk>
In-Reply-To: <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> (Alan Cox's message of "Tue, 24 Mar 2009 10:10:11 +0000")
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
Date: Tue, 24 Mar 2009 13:27:44 +0100
Message-ID: <87d4c7hzr3.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> > I have not had this problem since I applied Arjan's (for some reason
>> > repeatedly rejected) patch to change the ioprio of the various writeback
>> > daemons. Under some loads changing to the noop I/O scheduler also seems
>> > to help (as do most of the non default ones)
>> 
>> (link would be useful)
>
>
> "Give kjournald a IOPRIO_CLASS_RT io priority"
>
> October 2007 (yes its that old)

One issue discussed back then (also for a similar XFS patch) was
that having the kernel use the RT priorities by default makes
them useless as user override.

The proposal was to have a new priority level between normal and RT
for this, but noone implemented this.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
