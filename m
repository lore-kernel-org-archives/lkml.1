Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbXFPSSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbXFPSSj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 14:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbXFPSSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 14:18:33 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:16619 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbXFPSSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 14:18:32 -0400
Date: Sat, 16 Jun 2007 22:17:51 +0400
From: Dmitriy Monakhov <dmonakhov@sw.ru>
To: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       npiggin@suse.de, mark.fasheh@oracle.com, linux-ext4@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: iov_iter_fault_in_readable fix
Message-ID: <20070616181751.GE14349@localhost.sw.ru>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org, npiggin@suse.de,
	mark.fasheh@oracle.com, linux-ext4@vger.kernel.org, xfs@oss.sgi.com
References: <200705292119.l4TLJtAD011726@shell0.pdx.osdl.net> <20070613134005.GA13815@localhost.sw.ru> <20070613135759.GD13815@localhost.sw.ru> <20070614173153.GA14771@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070614173153.GA14771@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 18:31 Чтв 14 Июн     , Christoph Hellwig wrote:
> On Wed, Jun 13, 2007 at 05:57:59PM +0400, Dmitriy Monakhov wrote:
> >  	Function prerform check for signgle region, with out respect to
> >  	segment nature of iovec, For example writev no longer works :)
> 
> Btw, could someone please start to collect all sniplets like this in
> a nice simple regression test suite?  If no one wants to start a new
> one we should probably just put it into xfsqa (which should be useable
> for other filesystems aswell despite the name)
I've prepared testcase (testcases/kernel/syscalls/writev/writev06.c) 
and sent it to ltp mailing list.

