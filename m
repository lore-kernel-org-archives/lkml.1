Return-Path: <linux-kernel-owner+w=401wt.eu-S1752843AbXJWOlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbXJWOlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 10:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbXJWOlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 10:41:44 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:33282 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751916AbXJWOln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 10:41:43 -0400
Message-ID: <393150504.32739@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Tue, 23 Oct 2007 22:41:39 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Fengguang Wu <fengguang.wu@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] reiserfs: don't drop PG_dirty when releasing
	sub-page-sized dirty file
Message-ID: <20071023144139.GB6174@mail.ustc.edu.cn>
References: <200710220822.52370.maximlevitsky@gmail.com> <200710221421.21439.maximlevitsky@gmail.com> <393126119.26275@ustc.edu.cn> <200710231217.52147.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710231217.52147.maximlevitsky@gmail.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 12:17:51PM +0200, Maxim Levitsky wrote:
> > ---
> >  fs/reiserfs/stree.c |    3 ---
> >  1 file changed, 3 deletions(-)
> > 
> > --- linux-2.6.24-git17.orig/fs/reiserfs/stree.c
> > +++ linux-2.6.24-git17/fs/reiserfs/stree.c
> > @@ -1458,9 +1458,6 @@ static void unmap_buffers(struct page *p
> >  				}
> >  				bh = next;
> >  			} while (bh != head);
> > -			if (PAGE_SIZE == bh->b_size) {
> > -				cancel_dirty_page(page, PAGE_CACHE_SIZE);
> > -			}
> >  		}
> >  	}
> >  }
> > 
> > 
> 
> One thing to say... Works perfectly!
> Big thanks for fixing that bug.

And many thanks for your testing~

Fengguang

