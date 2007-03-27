Return-Path: <linux-kernel-owner+w=401wt.eu-S932911AbXC0V4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911AbXC0V4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 17:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932966AbXC0V4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 17:56:12 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:59714 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932911AbXC0V4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 17:56:10 -0400
Subject: Re: [patch] add file position info to proc
From: Dave Hansen <hansendc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20070325154541.6dcbd291.akpm@linux-foundation.org>
References: <E1HVELJ-0006ed-00@dorka.pomaz.szeredi.hu>
	 <20070325154541.6dcbd291.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 27 Mar 2007 14:55:56 -0700
Message-Id: <1175032556.16089.84.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-25 at 15:45 -0800, Andrew Morton wrote:
> On Sat, 24 Mar 2007 23:04:09 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > This patch adds support for finding out the current file position,
> > open flags and possibly other info in the future.
> > 
> > These new entries are added:
> > 
> >   /proc/PID/fdinfo/FD
> >   /proc/PID/task/TID/fdinfo/FD
> > 
> > For each fd the information is provided in the following format:
> > 
> > pos:	1234
> > flags:	0100002
> 
> I've seen the idea mentioned once or twice, but not with any great
> enthusiasm.  Why does Linux want this feature?

We can also use it for checkpoint/restart.  When restarting, we need to
put back the files in the same state they were in when we checkpointed.
This would at least allow us to do normal file checkpointing in
userspace.

-- Dave

