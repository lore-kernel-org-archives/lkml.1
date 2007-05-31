Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbXEaOUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbXEaOUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 10:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbXEaOUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 10:20:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33371 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbXEaOUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 10:20:40 -0400
Date: Thu, 31 May 2007 16:20:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/22] 2.6.22-rc3 perfmon2 : modified x86_64 files
Message-ID: <20070531142038.GB2538@one.firstfloor.org>
References: <200705291348.l4TDmYaf019853@frankl.hpl.hp.com> <p73ejkxc9un.fsf@bingen.suse.de> <20070531141600.GH22798@frankl.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531141600.GH22798@frankl.hpl.hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 07:16:00AM -0700, Stephane Eranian wrote:
> This is it. the check for uncommon bits is below (_TIF_WORK_CTXSW). Then
> we need to check each uncommon bits (done above). Did you have something else
> in mind?

Ah it's ok sorry.

> > Just use a cpu notifier instead. No need to add everybody's per cpu init code here.
> 
> The code must run on the CPU that is being initialized.

smp_call_function_single() 

> > 
> > No compat syscalls? 
> > 
> compat syscalls for what? I need to ensure backward compatiblity on IA-64 only.

For 32bit / i386 code.

-Andi
