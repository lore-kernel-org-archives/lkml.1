Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbXJ3OZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbXJ3OZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 10:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbXJ3OZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 10:25:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53277 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbXJ3OZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 10:25:47 -0400
Subject: Re: [PATCH 0/4] Unexport several headers and cleanup
From: David Woodhouse <dwmw2@infradead.org>
To: "Kirill A. Shutemov" <k.shutemov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071030135038.GA2429@localhost.localdomain>
References: <1193742139-29738-1-git-send-email-k.shutemov@gmail.com>
	 <1193748457.2915.163.camel@shinybook.infradead.org>
	 <20071030135038.GA2429@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 30 Oct 2007 10:25:56 -0400
Message-Id: <1193754356.2651.7.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-30 at 15:50 +0200, Kirill A. Shutemov wrote:
> It's bad idea. Taken from directfb:
> 
> #if HAVE_ASM_PAGE_H
> #include <asm/page.h>
> #else
> #define PAGE_SIZE   sysconf( _SC_PAGESIZE )
> #endif
> 
> Other application can use something like this. I think we should drop
> empty headers.

Well, it ought to be using sysconf unconditionally, but I take your
point. I'm happy enough then -- and since it doesn't change the kernel
build it could perhaps even be considered for 2.6.24.

Here you are... make sure you use them in the correct order:
Reviewed-By: David Woodhouse <dwmw2@infradead.org>
Reviewed-By: David Woodhouse <dwmw2@infradead.org>
Reviewed-By: David Woodhouse <dwmw2@infradead.org>
Reviewed-By: David Woodhouse <dwmw2@infradead.org>

-- 
dwmw2

