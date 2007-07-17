Return-Path: <linux-kernel-owner+w=401wt.eu-S1765529AbXGQHI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765529AbXGQHI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 03:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759148AbXGQHIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 03:08:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41667 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759029AbXGQHIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 03:08:16 -0400
Date: Tue, 17 Jul 2007 08:08:14 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kirill Kuvaldin <kuvkir@epsmu.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] isofs: mounting to regular file may succeed
Message-ID: <20070717070814.GA10395@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kirill Kuvaldin <kuvkir@epsmu.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <20070713234721.GG4536@zetta.epsmu.com> <20070717000407.4c854ec8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717000407.4c854ec8.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 12:04:07AM -0700, Andrew Morton wrote:
> I don't think any (all?) other filesystems perform checks like this.
> Is this something which can/should be performed at the VFS level?

As far as the VFS is concerned non-directory mounts are perfectly fine.
There's a lot of use cases for non-directory bind-mounts and at least
some for regular filesystems with a non-directory root.  E.g. the streams
folks are using something like that.    Solaris even ships with non-directory
root filesystems mounted by default these days.

