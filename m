Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbXC0XmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbXC0XmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 19:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbXC0XmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 19:42:25 -0400
Received: from kanga.kvack.org ([66.96.29.28]:49722 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbXC0XmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 19:42:24 -0400
Date: Tue, 27 Mar 2007 19:42:15 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Zach Brown <zach.brown@oracle.com>
Cc: linux-aio@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] aio: remove bare user-triggerable error printk
Message-ID: <20070327234215.GX17334@kvack.org>
References: <20070327224401.17758.17852.sendpatchset@tetsuo.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070327224401.17758.17852.sendpatchset@tetsuo.zabbo.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2007 at 03:44:01PM -0700, Zach Brown wrote:
> The user can generate console output if they cause do_mmap() to fail during
> sys_io_setup().  This was seen in a regression test that does exactly that by
> spinning calling mmap() until it gets -ENOMEM before calling io_setup().
> 
> We don't need this printk all, just remove it.
> 
> Signed-off-by: Zach Brown <zach.brown@oracle.com>

Yes.  Please!

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>

		-ben

-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <zyntrop@kvack.org>.
