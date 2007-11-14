Return-Path: <linux-kernel-owner+w=401wt.eu-S1761413AbXKNRof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761413AbXKNRof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 12:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757080AbXKNRoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 12:44:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39821 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbXKNRoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 12:44:23 -0500
Date: Wed, 14 Nov 2007 17:44:19 +0000
From: Christoph Hellwig <hch@infradead.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Christoph Hellwig <hch@infradead.org>, Chris Wedgwood <cw@f00f.org>,
       linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc2 XFS nfsd hang
Message-ID: <20071114174419.GA15271@infradead.org>
References: <20071114070400.GA25708@puku.stupidest.org> <20071114152952.GA4210@infradead.org> <20071114173922.GC14254@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114173922.GC14254@fieldses.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 12:39:22PM -0500, J. Bruce Fields wrote:
> This must have come up before; feel free to remind me: is there any way
> to make the interface easier to use?  (E.g. would it help if the filldir
> callback could be passed a dentry?)

The best thing for the filesystem would be to have a readdirplus
(or have it folded into readdir) instead of calling into lookup
from ->filldir.
