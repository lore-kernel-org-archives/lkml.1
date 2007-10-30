Return-Path: <linux-kernel-owner+w=401wt.eu-S1758859AbXJ3Xvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859AbXJ3Xvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 19:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758597AbXJ3Xuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:50:54 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:3423 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758551AbXJ3Xuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:50:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KO26pLzVJZhvrQTLitbxVzsHQgv66Zz3m/VA5zhODVOjVFqFojz3yyK3/g5tXk1hkbseh9XDpVY06AQD+fDqrhr900+PgrSCiVDq+y6IOWOKgAqxk/BHLm3qbFpIw3nxugD2g6e+duVcrD6+MG7dGE/NCvnHoao5oTxJmrBBzXw=
Message-ID: <8bd0f97a0710301650i4d71c358y1a35335d965d7e53@mail.gmail.com>
Date: Tue, 30 Oct 2007 19:50:51 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Kirill A. Shutemov" <k.shutemov@gmail.com>
Subject: Re: [PATCH 4/4] Cleanup asm/{elf,page,user}.h: #ifdef __KERNEL__ is no longer needed
Cc: "David Woodhouse" <dwmw2@infradead.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1193742139-29738-5-git-send-email-k.shutemov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1193742139-29738-1-git-send-email-k.shutemov@gmail.com>
	 <1193742139-29738-5-git-send-email-k.shutemov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/07, Kirill A. Shutemov <k.shutemov@gmail.com> wrote:
> asm/elf.h, asm/page.h and asm/user.h don't export to userspace now

as long as this is true ...

> we can drop #ifdef __KERNEL__ for them.

... this sounds great ... thanks (for Blackfin bits) :)
-mike
