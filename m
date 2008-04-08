Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbYDHH6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbYDHH6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 03:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbYDHH6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 03:58:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47135 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbYDHH6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 03:58:12 -0400
Date: Tue, 8 Apr 2008 03:58:07 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Neil Brown <neilb@suse.de>, "J. Bruce Fields" <bfields@fieldses.org>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: [NFS] Increase size of struct fid raw buffer
Message-ID: <20080408075807.GA8893@infradead.org>
References: <1207561677.3635.166.camel@quoit> <alpine.LFD.1.00.0804070850310.11277@woody.linux-foundation.org> <1207641005.3635.238.camel@quoit>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207641005.3635.238.camel@quoit>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2008 at 08:50:05AM +0100, Steven Whitehouse wrote:
> I'm happy with that solution, although I'd assumed that the reason this
> field had a size in the first place was that the NFS people had a plan
> to use the structure as an allocation entity in the future. Can an NFS
> developer please confirm/deny this?
> 
> If everybody is happy with the plan, then I'll send a patch to make the
> change as you suggest shortly,

I've introduce it and I don't plan to use it as allocation entity.  I
don't quite remember why I sized it either, so it's conceptually fine
to make it a VLA.  Just do some testing with that variant please.
