Return-Path: <linux-kernel-owner+w=401wt.eu-S1760593AbZB0VdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760593AbZB0VdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 16:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756519AbZB0VdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 16:33:00 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:43510 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376AbZB0Vc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 16:32:59 -0500
Subject: Re: [RFC][PATCH 4/8] file c/r: expose functions to query fs support
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: hch@infradead.org, containers <containers@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <1235769880.26788.394.camel@nimitz>
References: <20090227203425.F3B51176@kernel>
	 <20090227203429.6963AFC4@kernel> <20090227211408.GB19872@us.ibm.com>
	 <1235769880.26788.394.camel@nimitz>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 13:32:54 -0800
Message-Id: <1235770374.26788.395.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-27 at 13:24 -0800, Dave Hansen wrote:
> On Fri, 2009-02-27 at 13:14 -0800, Sukadev Bhattiprolu wrote:
> > Dave Hansen [dave@linux.vnet.ibm.com] wrote:
> > | +int cr_file_supported(struct file *file)
> > | +{
> > | +   struct inode *inode = file->f_dentry->d_inode;
> > | +   struct file_system_type *fs_type = inode->i_sb->s_type;
> > | +
> > | +   if (fs_is_cr_able(fs_type))
> > | +           return 0;
> > 
> > Should this be if (!fs_is_cr_able(fs_type)) ?
> 
> Yes.  I did find and fix that at some point, but it appears I didn't
> manage to integrate it into what I sent out.

Yeah, I think I managed to accidentally dump the fix into the next patch
instead of this one.  I'll correct that in the next set.

-- Dave

