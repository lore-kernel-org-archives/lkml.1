Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbXLCPJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbXLCPJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 10:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750706AbXLCPJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 10:09:13 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34763 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbXLCPJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 10:09:12 -0500
Date: Mon, 3 Dec 2007 15:09:05 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Timothy Shimmin <tes@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Chris Wedgwood <cw@f00f.org>,
       linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: revert to double-buffering readdir
Message-ID: <20071203150905.GA18082@infradead.org>
References: <20071114070400.GA25708@puku.stupidest.org> <20071125163014.GA17922@infradead.org> <474FBA21.4070201@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474FBA21.4070201@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 06:22:09PM +1100, Timothy Shimmin wrote:
> Hmmm, don't see the point of "eof" local var now.
> Previously bhv_vop_readdir() returned eof.
> I presume if we don't move the offset (offset == startoffset) then
> we're done and break out?
> So we lost eof when going to the filldir in the getdents code etc...

Yes, it's just copy & paste.  We can trivially kill the variable.

