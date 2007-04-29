Return-Path: <linux-kernel-owner+w=401wt.eu-S933351AbXD2QKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351AbXD2QKg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 12:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933454AbXD2QKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 12:10:36 -0400
Received: from gw.goop.org ([64.81.55.164]:60728 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933351AbXD2QJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 12:09:54 -0400
Message-ID: <4634C35C.8040303@goop.org>
Date: Sun, 29 Apr 2007 09:10:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm snapshot broken-out-2007-04-25-02-49.tar.gz uploaded
References: <200704250952.l3P9qIHh032233@shell0.pdx.osdl.net> <6bffcb0e0704251602x74e01dcbvf1d6eea565e3bbc5@mail.gmail.com> <6bffcb0e0704290636k3cea128ag44d7d6c9688a4e20@mail.gmail.com> <200704291555.57082.ak@suse.de>
In-Reply-To: <200704291555.57082.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> s/Friday/Sunday
>>
>> GOOD
>> ignore-stolen-time-in-the-softlockup-watchdog.patch
>> ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
>> BAD
>>     
>
> Thanks. I think the patch got dropped anyways. At least I don't have it anymore.
>   

Is this the testing failures in the locking tests when these patches are
in place?  It's very mysterious, but I don't see how it this patch can
cause the symptoms.  It looks like they're tickling a bug in lockdep or
the lock tests, but I don't have any insight into how...

    J
