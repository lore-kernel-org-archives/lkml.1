Return-Path: <linux-kernel-owner+w=401wt.eu-S1758947AbYAJIkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947AbYAJIkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 03:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbYAJIko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 03:40:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42957 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbYAJIko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 03:40:44 -0500
Date: Thu, 10 Jan 2008 08:40:41 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Evgeniy Dushistov <dushistov@mail.ru>, Steven <stevenaaus@yahoo.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: ufs: fix symlink creation on ufs2
Message-ID: <20080110084040.GD10745@infradead.org>
References: <20080102204649.GA16373@rain> <20080109235148.d5896897.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109235148.d5896897.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 11:51:48PM -0800, Andrew Morton wrote:
> > +++ b/fs/ufs/super.c
> > @@ -131,6 +131,8 @@ static void ufs_print_super_stuff(struct super_block *sb,
> >  		printk(KERN_INFO"  cs_nffree(Num of free frags): %llu\n",
> >  		       (unsigned long long)
> >  		       fs64_to_cpu(sb, usb3->fs_un1.fs_u2.cs_nffree));
> > +		printk(KERN_INFO"  fs_maxsymlinklen: %u\n",
> > +		       usb3->fs_un2.fs_44.fs_maxsymlinklen);
> 
> I assume this needs conversion via fs32_to_cpu() before we print it.

Yes, it does.  I wish people would run sparse before submitting patches :P

