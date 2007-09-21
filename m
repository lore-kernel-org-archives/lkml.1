Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbXIUMo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbXIUMo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 08:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbXIUMoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 08:44:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49398 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbXIUMoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 08:44:21 -0400
Date: Fri, 21 Sep 2007 13:44:20 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 4/5] VFS: allow filesystems to implement atomic open+truncate
Message-ID: <20070921124420.GB8088@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070921122343.307289079@szeredi.hu> <20070921123334.643828369@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921123334.643828369@szeredi.hu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 02:23:47PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Add a new attribute flag ATTR_OPEN, with the meaning: "truncation was
> initiated by open() due to the O_TRUNC flag".
> 
> This way filesystems wanting to implement truncation within their
> ->open() method can ignore such truncate requests.
> 
> This is a quick & dirty hack, but it comes for free.

Fine with me as it doesn't cause any active harm, but expect this to
go away once the nfs intent mess is cleaned up and we'll get a real
method for this kind of thing.

