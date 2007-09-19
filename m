Return-Path: <linux-kernel-owner+w=401wt.eu-S1764019AbXISRof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764019AbXISRof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763608AbXISRoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:44:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53330 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763491AbXISRoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:44:20 -0400
Date: Wed, 19 Sep 2007 18:44:18 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 00/24] Read-only bind mounts
Message-ID: <20070919174418.GA22982@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Hansen <haveblue@us.ibm.com>, akpm@osdl.org,
	linux-kernel@vger.kernel.org
References: <20070917182718.70494C9B@kernel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917182718.70494C9B@kernel>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 11:27:18AM -0700, Dave Hansen wrote:
> If we can't pull the entire series into -mm, can we just put the
> first three patches for now?  They can stand on their own.

Yes, they're kinda a series of their own.  But I still think we really
want this in -mm.  As we've seen on the kernel summit there's a pretty
desparate need for it.  And there's not many changes in this area in
-mm, maybe the unprivilegued mounts.  I'd personally prioritize the
r/o bindmounts over them as they're more needed and we need more reviewing
of the unprivilegued mounts (I'll try to come back to that soon).

FYI:  the series you sent out are missing the last two patches, and while
they compile as-is they're actually missing the interesting part :)
