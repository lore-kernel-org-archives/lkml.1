Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbYEaIYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbYEaIYO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 04:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYEaIX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 04:23:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41091 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbYEaIX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 04:23:57 -0400
Date: Sat, 31 May 2008 04:23:56 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 5/8] vfs: annotate permission operations
Message-ID: <20080531082356.GE24135@infradead.org>
References: <20080529113245.450308367@szeredi.hu> <20080529113314.181992948@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529113314.181992948@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 01:32:50PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Add more PERM_OP_ flags to permission() calls.  This allows
> filesystems like NFS and security modules like AppArmor to make
> precise decisions about whent permissions need to be checked, and when
> they will be checked later together with the actual operation.

Where the heck does this PERM_OP crap come from?  More MAY_ flags make
sense in some cases, but we should introduce them on a per-need basis
(e.g. to replace lookup intents in many cases), and without a new
PERM_OP_ namespace.

