Return-Path: <linux-kernel-owner+w=401wt.eu-S1759038AbYGKNra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038AbYGKNra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbYGKNrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:47:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43873 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499AbYGKNrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:47:19 -0400
Date: Fri, 11 Jul 2008 15:47:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] xen64: disable 32-bit syscall/sysenter if not
	supported.
Message-ID: <20080711134706.GB32159@elte.hu>
References: <48769A18.4030402@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48769A18.4030402@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Old versions of Xen (3.1 and before) don't support sysenter or syscall 
> from 32-bit compat userspaces.  If we can't set the appropriate 
> syscall callback, then disable the corresponding feature bit, which 
> will cause the vdso32 setup to fall back appropriately.
>
> Linux assumes that syscall is always available to 32-bit userspace, 
> and installs it by default if sysenter isn't available.  In that case, 
> we just disable vdso altogether, forcing userspace libc to fall back 
> to int $0x80.

merged the latest version of tip/x86/core to tip/xen-64bit and then 
added this patch to tip/xen-64bit - thanks Jeremy.

	Ingo
