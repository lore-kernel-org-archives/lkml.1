Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbYFJVTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbYFJVTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbYFJVTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:19:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754485AbYFJVTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:19:35 -0400
Date: Tue, 10 Jun 2008 14:18:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
       lee.schermerhorn@hp.com, riel@redhat.com
Subject: Re: + mm-only-vmscan-noreclaim-lru-scan-sysctl-fix.patch added to
 -mm tree
Message-Id: <20080610141838.896ee7aa.akpm@linux-foundation.org>
In-Reply-To: <484EE490.4060509@gmail.com>
References: <200806101837.m5AIbmiO023529@imap1.linux-foundation.org>
	<484EE490.4060509@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008 22:31:12 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> On 06/10/2008 08:37 PM, akpm@linux-foundation.org wrote:
> > Subject: mm-only-vmscan-noreclaim-lru-scan-sysctl-fix
> > From: Andrew Morton <akpm@linux-foundation.org>
> > 
> > build fix
> > 
> > Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
> > Cc: Rik van Riel <riel@redhat.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  mm/vmscan.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff -puN mm/vmscan.c~mm-only-vmscan-noreclaim-lru-scan-sysctl-fix mm/vmscan.c
> > --- a/mm/vmscan.c~mm-only-vmscan-noreclaim-lru-scan-sysctl-fix
> > +++ a/mm/vmscan.c
> > @@ -2400,6 +2400,7 @@ static void show_page_path(struct page *
> >  		       dentry_path(dentry, buf, 256), pgoff);
> >  		spin_unlock(&mapping->i_mmap_lock);
> >  	} else {
> > +#ifdef CONFG_MM_OWNER
> 
> s/CONFG/CONFIG/
> 

argh, thanks.  I'll update
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc5/2.6.26-rc5-mm2/hot-fixes/mm-only-vmscan-noreclaim-lru-scan-sysctl-fix.patch
in place once master.kernel.org wakes up again (it seems to be sulking at
present).

