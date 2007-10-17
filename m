Return-Path: <linux-kernel-owner+w=401wt.eu-S1761443AbXJQF3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761443AbXJQF3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 01:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbXJQF33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 01:29:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33052 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750844AbXJQF32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 01:29:28 -0400
Date: Tue, 16 Oct 2007 22:27:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Cc: Simon Horman <horms@verge.net.au>, Don Zickus <dzickus@redhat.com>,
       Neil Horman <nhorman@redhat.com>, Dan Aloni <da-x@monatomic.org>,
       Bernhard Walle <bwalle@suse.de>, kexec-ml <kexec@lists.infradead.org>,
       lkml <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@in.ibm.com>
Subject: Re: [PATCH 2/3] [kexec-tools] Pass vmcoreinfo's address and size
Message-Id: <20071016222744.a8f4b987.akpm@linux-foundation.org>
In-Reply-To: <47159AA3.10305@mxs.nes.nec.co.jp>
References: <20070822210838oomichi@mail.jp.nec.com>
	<20070822211339oomichi@mail.jp.nec.com>
	<20071017023305.GC6709@verge.net.au>
	<47159AA3.10305@mxs.nes.nec.co.jp>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 14:16:19 +0900 "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp> wrote:

> Simon Horman wrote:
> > On Wed, Aug 22, 2007 at 09:13:39PM +0900, Ken'ichi Ohmichi wrote:
> >> [2/3] [kexec-tools] Pass vmcoreinfo's address and size
> >> The patch is for kexec-tools-testing-20070330.
> >> (http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/)
> >> kexec command gets the address and size of the vmcoreinfo data from
> >> /sys/kernel/vmcoreinfo, and passes them to the second kernel through
> >> ELF header of /proc/vmcore. When the second kernel is booting, the
> >> kernel gets them from the ELF header and creates vmcoreinfo's PT_NOTE
> >> segment into /proc/vmcore.
> > 
> > Sorry for the long delay, I completely missed this patch.
> > 
> > The kexec-tools change seems ok to me. What is the status of
> > the kernel portion of the change?
> 
> The kernel portion is merged into linux-2.6.23-mm1.
> According to Andrew's mail "-mm merge plans for 2.6.24",  its status is
> "The infamous misc.  Will re-review and will merge basically all of them".

It's all in this evening's batch, which is going through final QA (heh)
now.  Is looking OK.

