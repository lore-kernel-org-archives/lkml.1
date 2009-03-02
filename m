Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbZCBJcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbZCBJcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 04:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756859AbZCBJcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 04:32:46 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37780 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756783AbZCBJcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 04:32:45 -0500
Message-ID: <49ABA633.2050903@redhat.com>
Date: Mon, 02 Mar 2009 10:26:11 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: core dom0 support
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <20090227212812.26d02f34.akpm@linux-foundation.org> <49A8DF28.4050301@goop.org> <20090228072055.GC9351@elte.hu>
In-Reply-To: <20090228072055.GC9351@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>> In three years time, will we regret having merged this?
>> Its a pretty minor amount of extra stuff on top of what's been 
>> added over the last 3 years, so I don't think it's going to 
>> tip the scales on its own.  I wouldn't be comfortable in 
>> trying to merge something that's very intrusive.
> 
> Hm, how can the same code that you call "massive out-of-tree 
> patches which doesn't make anyone happy" in an out of tree 
> context suddenly become non-intrusive "minor amount of extra 
> stuff" in an upstream context?

The current, out-of-tree xen kernel stuff is based on 2.6.18.  That
predates pv_ops and is quite intrusive stuff, with alot of cut+paste
programming and dirty hacks.

Alot has happened in x86 land since 2.6.18.  Being one of the x86 arch
maintainers you should know that very well.  Most notably:

  * pv_ops.  Point of adding these is to allow virtualization-friendly
    kernels *without* being intrusive as hell.
  * x86 arch merge, followed up by tons of cleanups and code
    reorganizations.  These changes also make it easier to merge xen
    support in a non-intrusive manner.

Also the xen support code in the linux kernel itself is basically a
rewrite from scratch, it hasn't much in common with the 2.6.18 code base.

> I wish the upstream kernel was able to do such magic, but i'm 
> afraid it is not.

It's no magic, it's alot of hard work.

cheers,
  Gerd


