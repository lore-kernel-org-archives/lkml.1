Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbYIIXcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbYIIXcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 19:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbYIIXcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 19:32:06 -0400
Received: from gw.goop.org ([64.81.55.164]:56938 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbYIIXcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 19:32:03 -0400
Message-ID: <48C70770.4070805@goop.org>
Date: Tue, 09 Sep 2008 16:32:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alex Nixon <alex.nixon@citrix.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] xen: fix pinning when not using split pte locks
References: <> <1220959508-13806-1-git-send-email-alex.nixon@citrix.com> <48C6BB00.9040607@goop.org> <48C6CCD7.8030800@citrix.com> <48C6DE6E.1070804@goop.org> <48C6F80E.8010509@citrix.com> <48C6FC0D.9040009@goop.org> <48C70526.1030701@citrix.com>
In-Reply-To: <48C70526.1030701@citrix.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Nixon wrote:
> Jeremy Fitzhardinge wrote:
>> We only pin PTE pages when using split PTE locks, so don't do the
>> pin/unpin when attaching/detaching pte pages to a pinned pagetable.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>> ---
>>   
> Cheers Jeremy - a better solution.  Worth mentioning - this doesn't
> exist peacefully alongside my patch 965fe78fe
>
> Ingo - could you revert that please?

Yes.  Also, could you wait for an Ack from me before committing anything
Xen related?  And Alex, could you be sure to explicitly cc: me on Xen
patches?

Thanks,
    J
