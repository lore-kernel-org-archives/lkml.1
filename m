Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbZCRRyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbZCRRyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 13:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759198AbZCRRxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 13:53:52 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:49344 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758883AbZCRRxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 13:53:51 -0400
Subject: Re: C/R review
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: orenl@cs.columbia.edu, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, mingo@elte.hu
In-Reply-To: <20090317210110.GA3897@x200.localdomain>
References: <20090317210110.GA3897@x200.localdomain>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 10:53:34 -0700
Message-Id: <1237398814.8286.174.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-18 at 00:01 +0300, Alexey Dobriyan wrote:
> > +static inline loff_t file_pos_read(struct file *file)
> > +{
> > +     return file->f_pos;
> > +}
> > +
> > +static inline void file_pos_write(struct file *file, loff_t pos)
> > +{
> > +     file->f_pos = pos;
> > +}
> 
> I failed myself to understand need for this wrappers at all.
> 
> If dump is single-threaded, who is going to change f_pos under you?
> 
> I'm passing &file->f_pos to vfs_write().

/me git-blames...

They're already in the kernel and they've been there since the beginning
of git as far as I can see.  I think Oren was just trying to use what is
there already, so he moved them to a header.

-- Dave

