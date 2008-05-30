Return-Path: <linux-kernel-owner+w=401wt.eu-S1756966AbYE3FqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbYE3FqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 01:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYE3Fpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 01:45:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49493 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbYE3Fpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 01:45:53 -0400
Subject: Re: linux/a.out.h is not exported to userspace
From: David Woodhouse <dwmw2@infradead.org>
To: Khem Raj <raj.khem@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, k.shutemov@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <1212122144.32524.8.camel@isis>
References: <1210983237.8550.28.camel@isis>
	 <20080523003256.3ff82660.akpm@linux-foundation.org>
	 <1212122144.32524.8.camel@isis>
Content-Type: text/plain
Date: Fri, 30 May 2008 08:45:47 +0300
Message-Id: <1212126347.20303.11.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-29 at 21:35 -0700, Khem Raj wrote:
> On Fri, 2008-05-23 at 00:32 -0700, Andrew Morton wrote:
> > On Fri, 16 May 2008 17:13:57 -0700 Khem Raj <raj.khem@gmail.com> wrote:
> 
> > 
> > This breaks `make headerscheck' on s390:
> > 
> > /usr/src/devel/usr/include/linux/a.out.h requires asm/a.out.h, which does not exist in exported headers
> > 
> > which might be an s390 problem.
> 
> The attached patch from David is a replacement patch. I have tested this
> patch by running make headers_install on every architecture under arch/
> It works for all (except 'um' and 'ppc' which do not export headers)

We also need to remove the instance of #ifdef CONFIG_something which
David sneaked in to <linux/a.out.h>.

And make a 'headers_check' test for it :)

-- 
dwmw2

