Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbYIJOVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbYIJOVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 10:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbYIJOU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 10:20:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40710 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbYIJOU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 10:20:56 -0400
Subject: Re: [PATCH] include <linux/types.h> into linux/dlm_plock.h for
	__u* typedef
From: David Woodhouse <dwmw2@infradead.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
       Christine Caulfield <caulfie@redhat.com>,
       David Teigland <teigland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080910121450.GA3468@x200.localdomain>
References: <1221045726-5674-1-git-send-email-kirill@shutemov.name>
	 <1221045726-5674-2-git-send-email-kirill@shutemov.name>
	 <20080910121450.GA3468@x200.localdomain>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 07:20:50 -0700
Message-Id: <1221056450.4260.17.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-10 at 16:14 +0400, Alexey Dobriyan wrote:
> On Wed, Sep 10, 2008 at 02:22:04PM +0300, Kirill A. Shutemov wrote:
> > --- a/include/linux/dlm_plock.h
> > +++ b/include/linux/dlm_plock.h
> 
> > +#include <linux/types.h>
> 
> I'd say that unless you can demonstrate compilation breakage, these will
> only slow down compilation.

Not really. GCC notices the include guard pattern and won't even bother
to open the file the second and subsequent time it's included within a
compilation. I'd be astonished if you can measure any real slowdown at
all.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

