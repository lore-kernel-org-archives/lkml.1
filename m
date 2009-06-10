Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbZFJKEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbZFJKEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 06:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbZFJKDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 06:03:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34485 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbZFJKDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 06:03:52 -0400
Subject: Re: [PATCH 23/24] GFS2: Fix locking issue mounting gfs2meta fs
From: Steven Whitehouse <swhiteho@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
In-Reply-To: <20090610095319.GC25527@infradead.org>
References: <1244622665-7470-15-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-16-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-17-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-18-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-19-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-20-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-21-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-22-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-23-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-24-git-send-email-swhiteho@redhat.com>
	 <20090610095319.GC25527@infradead.org>
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Wed, 10 Jun 2009 11:06:06 +0100
Message-Id: <1244628366.3355.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2009-06-10 at 05:53 -0400, Christoph Hellwig wrote:
> On Wed, Jun 10, 2009 at 09:31:04AM +0100, Steven Whitehouse wrote:
> >  static struct super_block *get_gfs2_sb(const char *dev_name)
> >  {
> > -	struct super_block *sb;
> 
> Any reason you don't merge get_gfs2_sb into gfs2_get_sb_meta?  That's
> how most other get_sb callbacks are structured, and would also get rid
> of the rather confusing get_gfs2_sb name.
> 

Well originally I was expecting to share that code with the
gfs2_get_sb() but since that patch has been dropped now, I guess there
is no reason not to merge them,

Steve.


