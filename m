Return-Path: <linux-kernel-owner+w=401wt.eu-S1757617AbXIBSUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617AbXIBSUd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 14:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbXIBSUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 14:20:24 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:42706 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbXIBSUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 14:20:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FVYMfPxwx/Uu00wk+kXA2TCDWIlHl+CjvFV2LvxIFw1gKmWv5kJKX1HiABvtE0j3lA6m71WH9l1yOBuxz7Xc8/6cQN78fyctbO844hn+pg1B/esFWOCUBBAtbB4q/l/S/KWP50UmeYoeHycRVorVmXPAflzGemu6f9+VDxE3HJ8=
Message-ID: <1defaf580709021120y20d1c4dfo948ebb1b5206e980@mail.gmail.com>
Date: Sun, 2 Sep 2007 20:20:22 +0200
From: "=?ISO-8859-1?Q?H=E5vard_Skinnemoen?=" <hskinnemoen@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: the Linux kernel, testsuites, and maybe *you*
Cc: "Mike Frysinger" <vapier.adi@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070902065926.GA15487@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0708311422u309ff09cs24dfe64ff535a982@mail.gmail.com>
	 <p733axyxcli.fsf@bingen.suse.de>
	 <8bd0f97a0709011550y833fb5ax7d40cae937789fd8@mail.gmail.com>
	 <20070902065926.GA15487@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/2/07, Andi Kleen <andi@firstfloor.org> wrote:
> The other issue to test some of them properly you need unmapped pages
> etc. That gets much easier to do in user space. There are some other
> issues.

vmalloc, vmap, etc. always put a guard page after the allocation. So
if you test string operations on vmalloc()'ed memory, you have
unmapped pages in both ends.

I like the idea of a test suite for kernel internals, but I also think
it would be best to run it in kernel mode since things like atomics,
etc. may work differently in user space on some architectures.

Haavard
