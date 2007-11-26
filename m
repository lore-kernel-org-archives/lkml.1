Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbXKZOdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbXKZOdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 09:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbXKZOd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 09:33:27 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58445 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbXKZOd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 09:33:27 -0500
Date: Mon, 26 Nov 2007 14:33:05 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       hch@infradead.org
Subject: Re: [PATCH 05/27] rename open_namei() to open_pathname()
Message-ID: <20071126143305.GA10266@infradead.org>
References: <20071101230826.9A4F6E00@kernel> <20071101230832.9835ED1E@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071101230832.9835ED1E@kernel>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 04:08:32PM -0700, Dave Hansen wrote:
> 
> open_namei() no longer touches namei's.  rename it
> to something more appropriate: open_pathname().

The name is quite non-descriptive.  What about just leaving it as
filp_open and merging this into the previous patches to avoid
the spurious renaming?

And btw, exported functions that get half-rewritten should always
grow a kerneldoc comment.  Then again this particular one really
shouldn't be exported, but that's for another series.
