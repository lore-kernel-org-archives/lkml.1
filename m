Return-Path: <linux-kernel-owner+w=401wt.eu-S1758837AbYG2UWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbYG2UWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYG2UWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:22:00 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:43248 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbYG2UV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:21:59 -0400
Date: Wed, 30 Jul 2008 01:51:34 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: kernel BUG at arch/x86/kernel/io_apic_64.c:357!
Message-ID: <20080729202134.GC4484@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080729160939.GA4484@linux.vnet.ibm.com> <86802c440807291135m7f8e2163xdde14545e311649a@mail.gmail.com> <86802c440807291220t7813effcwb32ae6c18e3cddfe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807291220t7813effcwb32ae6c18e3cddfe@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 12:20:01PM -0700, Yinghai Lu wrote:
> On Tue, Jul 29, 2008 at 11:35 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > On Tue, Jul 29, 2008 at 9:09 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> >> Hi Ingo, Thomas,
> >>
> >> Hit this on 2.6.27-rc1
> >>
> >> (The kernel bug is at line 356 (Its 357 as I applied a debug patch to
> >> print out the irq) (Full dmesg and .config attached)
> >
> > can you boot with "debug apic=verbose pci=routeirq"?
> 
> please try attached patch
> 

Thanks. The patch gets my system to boot.

-- 
regards,
Dhaval
