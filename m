Return-Path: <linux-kernel-owner+w=401wt.eu-S1755639AbZFJJxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbZFJJxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbZFJJxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:53:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43849 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbZFJJxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:53:17 -0400
Date: Wed, 10 Jun 2009 05:53:19 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 23/24] GFS2: Fix locking issue mounting gfs2meta fs
Message-ID: <20090610095319.GC25527@infradead.org>
References: <1244622665-7470-15-git-send-email-swhiteho@redhat.com> <1244622665-7470-16-git-send-email-swhiteho@redhat.com> <1244622665-7470-17-git-send-email-swhiteho@redhat.com> <1244622665-7470-18-git-send-email-swhiteho@redhat.com> <1244622665-7470-19-git-send-email-swhiteho@redhat.com> <1244622665-7470-20-git-send-email-swhiteho@redhat.com> <1244622665-7470-21-git-send-email-swhiteho@redhat.com> <1244622665-7470-22-git-send-email-swhiteho@redhat.com> <1244622665-7470-23-git-send-email-swhiteho@redhat.com> <1244622665-7470-24-git-send-email-swhiteho@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244622665-7470-24-git-send-email-swhiteho@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 09:31:04AM +0100, Steven Whitehouse wrote:
>  static struct super_block *get_gfs2_sb(const char *dev_name)
>  {
> -	struct super_block *sb;

Any reason you don't merge get_gfs2_sb into gfs2_get_sb_meta?  That's
how most other get_sb callbacks are structured, and would also get rid
of the rather confusing get_gfs2_sb name.

