Return-Path: <linux-kernel-owner+w=401wt.eu-S1763433AbXJNVD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763433AbXJNVD6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 17:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759393AbXJNVDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 17:03:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49507 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758837AbXJNVDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 17:03:50 -0400
Date: Sun, 14 Oct 2007 22:03:41 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove GPL restriction from set_dumpable()
Message-ID: <20071014210341.GA30029@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jiri Kosina <jkosina@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0710141257030.20620@jikos.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710141257030.20620@jikos.suse.cz>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2007 at 01:04:31PM +0200, Jiri Kosina wrote:
> From: Jiri Kosina <jkosina@suse.cz>
> 
> remove GPL restriction from set_dumpable()
> 
> Commit 6c5d5238 introduced a set_dumpable() function that replaced the 
> direct access to mm_struct->dumpable. I don't think there is any reason to 
> restrict this function to EXPORT_SYMBOL_GPL() -- previously any module 
> could modify current->mm->dumpable without any resitrictions, so it makes 
> a little sense to turn this into 'internal interface' at once.
> 
> There in fact are 3rd party modules that modify the dumpable flag, and 
> this patch should fix the situation for them once again (for example 
> vmware).

Nack, the just shouldn't do such things at all.  I start to get really
sick of patches adding random exports everywhere.

