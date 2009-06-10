Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbZFJJtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbZFJJtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbZFJJtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:49:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43569 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbZFJJtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:49:40 -0400
Date: Wed, 10 Jun 2009 05:49:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: Re: [PATCH 10/24] GFS2: Don't warn when delete inode fails on ro
	filesystem
Message-ID: <20090610094942.GB25527@infradead.org>
References: <1244622665-7470-2-git-send-email-swhiteho@redhat.com> <1244622665-7470-3-git-send-email-swhiteho@redhat.com> <1244622665-7470-4-git-send-email-swhiteho@redhat.com> <1244622665-7470-5-git-send-email-swhiteho@redhat.com> <1244622665-7470-6-git-send-email-swhiteho@redhat.com> <1244622665-7470-7-git-send-email-swhiteho@redhat.com> <1244622665-7470-8-git-send-email-swhiteho@redhat.com> <1244622665-7470-9-git-send-email-swhiteho@redhat.com> <1244622665-7470-10-git-send-email-swhiteho@redhat.com> <1244622665-7470-11-git-send-email-swhiteho@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244622665-7470-11-git-send-email-swhiteho@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 09:30:51AM +0100, Steven Whitehouse wrote:
> If the filesystem is read-only, then we expect that delete inode
> will fail, so there is no need to warn about it.

Umm, ->delete_inode should never be called on a read-only filesystem
by the VFS.

