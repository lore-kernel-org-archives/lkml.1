Return-Path: <linux-kernel-owner+w=401wt.eu-S1760378AbZB0VY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760378AbZB0VY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 16:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758214AbZB0VYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 16:24:48 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:42799 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758071AbZB0VYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 16:24:48 -0500
Subject: Re: [RFC][PATCH 4/8] file c/r: expose functions to query fs support
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       hch@infradead.org, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20090227211408.GB19872@us.ibm.com>
References: <20090227203425.F3B51176@kernel>
	 <20090227203429.6963AFC4@kernel>  <20090227211408.GB19872@us.ibm.com>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 13:24:40 -0800
Message-Id: <1235769880.26788.394.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-27 at 13:14 -0800, Sukadev Bhattiprolu wrote:
> Dave Hansen [dave@linux.vnet.ibm.com] wrote:
> | +int cr_file_supported(struct file *file)
> | +{
> | +	struct inode *inode = file->f_dentry->d_inode;
> | +	struct file_system_type *fs_type = inode->i_sb->s_type;
> | +
> | +	if (fs_is_cr_able(fs_type))
> | +		return 0;
> 
> Should this be if (!fs_is_cr_able(fs_type)) ?

Yes.  I did find and fix that at some point, but it appears I didn't
manage to integrate it into what I sent out.

Thanks, Suka.

-- Dave

