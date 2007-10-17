Return-Path: <linux-kernel-owner+w=401wt.eu-S1758659AbXJQI6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758659AbXJQI6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 04:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbXJQI6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 04:58:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37564 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbXJQI6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 04:58:40 -0400
Date: Wed, 17 Oct 2007 09:58:32 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Laurent Riffard <laurent.riffard@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, reiserfs-devel@vger.kernel.org
Subject: Re: 2.6.23-mm1: BUG in reiserfs_delete_xattrs
Message-ID: <20071017085832.GA8072@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jeff Mahoney <jeffm@suse.com>,
	Laurent Riffard <laurent.riffard@free.fr>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, reiserfs-devel@vger.kernel.org
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <47129992.4040903@free.fr> <20071015084052.GA21870@infradead.org> <4713B1E7.2010504@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4713B1E7.2010504@suse.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 02:31:03PM -0400, Jeff Mahoney wrote:
> Here's a patch I worked up the other night that kills off struct file
> completely from the xattr code. I've tested it locally.

Looks like a merge of Dave's and my patch :)

ACK from me, I don't care whether it's one or two patches.
