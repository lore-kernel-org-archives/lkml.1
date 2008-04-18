Return-Path: <linux-kernel-owner+w=401wt.eu-S1757802AbYDRQCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802AbYDRQCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 12:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbYDRQCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 12:02:32 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:64537 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbYDRQCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 12:02:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oHMxGEDMk6j9PToZvZrCF7MeKGJj4JqwdymPhH4LU/RgBy7z5hRxBxPpqpbYX9CgR2MFfcBL0BKFovHhaYu7R3NyGABTysw14cWfm7VidqcpiHAPinTEeN5srN1+V9hZf18yUs0jce9ZBXxH2kzQxfrrpf19AdP7gMqG4SwMKZs=
Message-ID: <19f34abd0804180902k7a91ace3q84720e0352c3aa40@mail.gmail.com>
Date: Fri, 18 Apr 2008 18:02:29 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Jason Wessel" <jason.wessel@windriver.com>
Subject: Re: 2.6.25-mm1: not looking good
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       tglx@linutronix.de, penberg@cs.helsinki.fi, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, jmorris@namei.org,
       sds@tycho.nsa.gov
In-Reply-To: <19f34abd0804180747i244c483flf8421f42a330c519@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080417160331.b4729f0c.akpm@linux-foundation.org>
	 <48080FE7.1070400@windriver.com> <20080418073732.GA22724@elte.hu>
	 <19f34abd0804180446u2d6f17damf391a8c0584358b8@mail.gmail.com>
	 <20080418123439.GA17013@elte.hu>
	 <19f34abd0804180541l7b4d14a6tb13bdd51dd533d70@mail.gmail.com>
	 <48089BCA.1090704@windriver.com>
	 <19f34abd0804180622l4f89191cp4cc7833822e058f5@mail.gmail.com>
	 <4808A1C7.7000907@windriver.com>
	 <19f34abd0804180747i244c483flf8421f42a330c519@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 4:47 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>
> On 4/18/08, Jason Wessel <jason.wessel@windriver.com> wrote:
>  > Vegard Nossum wrote:
>  > > On Fri, Apr 18, 2008 at 3:02 PM, Jason Wessel
>  > > <jason.wessel@windriver.com> wrote:
>  > >>  I assume this was SMP?
...

>  But booting with nosmp on real hardware gets easily above 100,000
>  iterations of the loop (before I reboot), so it seems to be related to
>  that, anyway.

It gets stuck in kgdb_roundup_cpus(), verified by putting a printk()
before and after this call (in kgdb_handle_exception()). Simple, but
effective :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
