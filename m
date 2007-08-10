Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbXHJRKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbXHJRKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 13:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbXHJRKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 13:10:35 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59858 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750851AbXHJRKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 13:10:34 -0400
Date: Fri, 10 Aug 2007 18:16:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@sw.ru>, axboe@kernel.dk
Subject: Re: [PATCH 08/10] sysctl: Remove broken cdrom binary sysctls
Message-ID: <20070810181632.3a491575@the-village.bc.nu>
In-Reply-To: <m17io3z8o2.fsf@ebiederm.dsl.xmission.com>
References: <20070726164518.GB16937@localhost.sw.ru>
	<m13azbulhf.fsf@ebiederm.dsl.xmission.com>
	<20070727145235.GC6924@localhost.sw.ru>
	<20070806124530.GD6634@localhost.sw.ru>
	<m1tzr8a3ms.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps1wa3kf.fsf_-_@ebiederm.dsl.xmission.com>
	<m1hcn8a2rq.fsf_-_@ebiederm.dsl.xmission.com>
	<m1d4xw9psl.fsf_-_@ebiederm.dsl.xmission.com>
	<m18x8k9ppv.fsf_-_@ebiederm.dsl.xmission.com>
	<m14pj89pmt.fsf_-_@ebiederm.dsl.xmission.com>
	<m1zm108axi.fsf_-_@ebiederm.dsl.xmission.com>
	<m1vebo8avf.fsf_-_@ebiederm.dsl.xmission.com>
	<m1r6mc8at5.fsf_-_@ebiederm.dsl.xmission.com>
	<m1myx08arh.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ir7o8ap1.fsf_-_@ebiederm.dsl.xmission.com>
	<20070810143342.173d2637@the-village.bc.nu>
	<m17io3z8o2.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> In that code we could just do a test on valp (i.e. data in struct
> ctl_table).

Or you could pass the struct pointer and subtract the array start

> I just wanted something stupid and simple, so the -mm tree would not
> be full of broken sysctls.

Well I'd like you to not replace one pile of hard to clean up but easy to
locate crap by smearing other hard to fix in one go crap over the kernel.
> 
> At least to my eyes the code doesn't look much worse.  But if you
> want to do something better feel free.

I'll add it to my todo list. But in the meantime I still NAK the change.
I'll try and get a patch sorted but it'll be after the kernel summit for
sure.
