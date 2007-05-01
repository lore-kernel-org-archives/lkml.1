Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbXEADdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbXEADdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 23:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755478AbXEADdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 23:33:18 -0400
Received: from mail.fieldses.org ([66.93.2.214]:35995 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270AbXEADdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:33:17 -0400
Date: Mon, 30 Apr 2007 23:33:10 -0400
To: Neil Brown <neilb@suse.de>
Cc: Jeff Layton <jlayton@redhat.com>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [NFS] [PATCH] RPC: add wrapper for svc_reserve to account for	checksum
Message-ID: <20070501033310.GB21774@fieldses.org>
References: <20070421131523.GA18100@dantu.rdu.redhat.com> <17974.41587.666167.650575@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17974.41587.666167.650575@notabene.brown>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 12:14:11PM +1000, Neil Brown wrote:
> I don't think this BUG_ON is correct.  If a readdir finds zero entries,
> then will be some trailer information in the 'tail', but page_len will
> be 0.  I think the following patch is correct and could fix that.

Yep.

> Bruce:  does it look OK to you?

It looks sensible, but it's a little late for me--I'll take another look
at it and run some tests tommorow.

--b.
