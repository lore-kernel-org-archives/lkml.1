Return-Path: <linux-kernel-owner+w=401wt.eu-S1763523AbXJQI70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763523AbXJQI70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 04:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbXJQI7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 04:59:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37580 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbXJQI7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 04:59:10 -0400
Date: Wed, 17 Oct 2007 09:59:06 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Laurent Riffard <laurent.riffard@free.fr>
Cc: Jeff Mahoney <jeffm@suse.com>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, reiserfs-devel@vger.kernel.org
Subject: Re: 2.6.23-mm1: BUG in reiserfs_delete_xattrs
Message-ID: <20071017085906.GB8072@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Laurent Riffard <laurent.riffard@free.fr>,
	Jeff Mahoney <jeffm@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, reiserfs-devel@vger.kernel.org
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <47129992.4040903@free.fr> <20071015084052.GA21870@infradead.org> <4713B1E7.2010504@suse.com> <4713C82C.7020609@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4713C82C.7020609@free.fr>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 10:06:04PM +0200, Laurent Riffard wrote:
> > Here's a patch I worked up the other night that kills off struct file
> > completely from the xattr code. I've tested it locally.
> 
> Sorry Jeff, your patch does not apply on 2.6.23-mm1. The 'struct file'
> removal from reiserfs_xattr_ function is already in -mm
> (make-reiserfs-stop-using-struct-file-for-internal.patch).

We'll need to drop Dave's patch first.  Andrew, can you drop it and
put this one in instead?

