Return-Path: <linux-kernel-owner+w=401wt.eu-S935417AbXJPTLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935417AbXJPTLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 15:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934343AbXJPTLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 15:11:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934265AbXJPTLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 15:11:23 -0400
Date: Tue, 16 Oct 2007 14:35:10 -0400
From: Dave Jones <davej@redhat.com>
To: Arnaud Fontaine <arnaud@andesi.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: error: Eeek! page_mapcount(page) went negative! (-1) with
	different process and kernels
Message-ID: <20071016183510.GB25480@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Arnaud Fontaine <arnaud@andesi.org>, linux-kernel@vger.kernel.org
References: <sa564176ksz.fsf@Toushirou.duckcorp.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sa564176ksz.fsf@Toushirou.duckcorp.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 07:17:32PM +0200, Arnaud Fontaine wrote:
 > Hello,
 > 
 > We have often the following error from the kernel:
 > 

 >  sshd[1551] trap invalid opcode rip:2aeacc0677a0 rsp:7fffe0c7e688 error:0
 >  Eeek! page_mapcount(page) went negative! (-1)
 >    page pfn = 7f7a8
 >    page->flags = 400000000001002c
 >    page->count = 1
 >    page->mapping = ffff810056170550
 >    vma->vm_ops = 0xffffffff80667ba0
 >    vma->vm_ops->nopage = _stext+0x7fdf7000/0x20
 >    vma->vm_ops->fault = filemap_fault+0x0/0x450
 >    vma->vm_file->f_op->mmap = generic_file_mmap+0x0/0x50
 > ....
 > 
 > We have tested with different  kernel (2.6.23.1 and 2.6.22) and the same
 > error happens  with different process.  Any idea for knowing  what could
 > cause this error?

Many of these that I've seen have turned out to be a hardware problem.
Try running memtest86+ on that machine for a while.
It doesn't catch all problems, but it will highlight more common memory faults.

	Dave

-- 
http://www.codemonkey.org.uk
