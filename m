Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZCHWA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZCHWA5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 18:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbZCHWAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 18:00:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59248 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbZCHWAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 18:00:47 -0400
Message-ID: <49B43F1D.2000400@zytor.com>
Date: Sun, 08 Mar 2009 14:56:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: core dom0 support
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <20090227212812.26d02f34.akpm@linux-foundation.org> <20090228084254.GA29342@elte.hu> <49A907DD.6010408@goop.org> <20090302120859.GB29015@elte.hu> <49B23907.8030103@goop.org> <20090308110150.GA19151@elte.hu>
In-Reply-To: <20090308110150.GA19151@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> Associativity effects do depend on the kernel image layout and 
> on the precise allocations of kernel data structure allocations 
> we do during bootup - and they dont really change after that.
> 

By the way, there is a really easy way (if a bit time consuming) to get
the actual variability here -- you have to reboot between runs, even for
the same kernel.  It makes the data collection take a long time, but at
least it can be scripted.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

