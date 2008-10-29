Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbYJ2KE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbYJ2KE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 06:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbYJ2KEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 06:04:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46968 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbYJ2KEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 06:04:50 -0400
Date: Wed, 29 Oct 2008 06:04:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, torvalds@osdl.org,
       viro@zeniv.linux.org.uk, acme@ghostprotocols.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] headers: move release_kernel_lock(),
	reacquire_kernel_lock() to sched.c
Message-ID: <20081029100437.GA30492@infradead.org>
References: <20081029044351.GA2304@x200.localdomain> <20081029044447.GB2304@x200.localdomain> <20081029061827.GA7936@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029061827.GA7936@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 07:18:27AM +0100, Ingo Molnar wrote:
> please dont move #ifdefs and interfaces into a .c file - if then move 
> it into another header file.

Sorry, but that makes no sense at all.  This stuff is implementation
private to sched.c, and adding some header for it is just braindead.

