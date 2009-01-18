Return-Path: <linux-kernel-owner+w=401wt.eu-S934464AbZARRcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934464AbZARRcO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 12:32:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764991AbZARRb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 12:31:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52686 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758483AbZARRb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 12:31:57 -0500
Date: Sun, 18 Jan 2009 12:31:44 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: spurious -ENOSPC on XFS
Message-ID: <20090118173144.GA1999@infradead.org>
References: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com> <20090113214949.GN8071@disturbed> <Pine.LNX.4.64.0901132324070.16396@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901132324070.16396@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 11:28:58PM -0500, Mikulas Patocka wrote:
> The result must not depend on magic timer values. If it does, you end up 
> with undebbugable nondeterministic failures.
> 
> Why don't you change that 500ms wait to "wait until the flush finishes"? 
> That would be correct.

Yes, this probably would better.  Could I motivate you to come up with
a patch for that?

