Return-Path: <linux-kernel-owner+w=401wt.eu-S1763104AbXJQNiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763104AbXJQNiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 09:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbXJQNhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 09:37:55 -0400
Received: from koto.vergenet.net ([210.128.90.7]:48404 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212AbXJQNhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 09:37:54 -0400
Date: Wed, 17 Oct 2007 22:37:45 +0900
From: Simon Horman <horms@verge.net.au>
To: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, Don Zickus <dzickus@redhat.com>,
       Neil Horman <nhorman@redhat.com>, Dan Aloni <da-x@monatomic.org>,
       Bernhard Walle <bwalle@suse.de>, kexec-ml <kexec@lists.infradead.org>,
       lkml <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@in.ibm.com>
Subject: Re: [PATCH 2/3] [kexec-tools] Pass vmcoreinfo's address and size
Message-ID: <20071017133743.GA4211@verge.net.au>
References: <20070822210838oomichi@mail.jp.nec.com> <20070822211339oomichi@mail.jp.nec.com> <20071017023305.GC6709@verge.net.au> <47159AA3.10305@mxs.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47159AA3.10305@mxs.nes.nec.co.jp>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 02:16:19PM +0900, Ken'ichi Ohmichi wrote:
> 
> Hi Simon,
> 
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
> 
> http://www.ussg.iu.edu/hypermail/linux/kernel/0710.0/0313.html
> 
> 
> > Do you still want the kexec-tools portion applied?
> 
> Yes, I hope so.

Thanks, I'll try and look over it tomorrow.
