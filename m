Return-Path: <linux-kernel-owner+w=401wt.eu-S965364AbXJPTBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965364AbXJPTBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 15:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933949AbXJPTAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 15:00:49 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:39200 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933746AbXJPTAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 15:00:48 -0400
Date: Tue, 16 Oct 2007 20:00:44 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: Build breakage if !SYSFS
Message-ID: <20071016190044.GA24696@linux-mips.org>
References: <20071016130231.GA10778@linux-mips.org> <20071016174016.GC5693@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016174016.GC5693@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 11:10:16PM +0530, Dhaval Giani wrote:

> On Tue, Oct 16, 2007 at 02:02:31PM +0100, Ralf Baechle wrote:
> > Changeset 5cb350baf580017da38199625b7365b1763d7180 causes build breakage
> > if sysfs support is disabled:
> > 
> > kernel/built-in.o: In function `uids_kobject_init':
> > (.init.text+0x1488): undefined reference to `kernel_subsys'
> > kernel/built-in.o: In function `uids_kobject_init':
> > (.init.text+0x1490): undefined reference to `kernel_subsys'
> > kernel/built-in.o: In function `uids_kobject_init':
> > (.init.text+0x1480): undefined reference to `kernel_subsys'
> > kernel/built-in.o: In function `uids_kobject_init':
> > (.init.text+0x1494): undefined reference to `kernel_subsys'
> > 
> > This breaks for example mipssim_defconfig.
> > 
> >   Ralf
> 
> Hi Ralf,
> 
> Can you try this and confirm if it works?

Yes, this solves the issue.

Thanks,

  Ralf
