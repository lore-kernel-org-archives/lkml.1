Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752466AbYLQVLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbYLQVLB (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 16:11:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYLQVKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 16:10:50 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48169 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbYLQVKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 16:10:50 -0500
Subject: Re: [PATCH 11/15] fixing audit rule ordering mess, part 1
From: Eric Paris <eparis@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20081217205902.GH28946@ZenIV.linux.org.uk>
References: <E1LCoiI-0000Eu-Ty@ZenIV.linux.org.uk>
	 <1229538488.3384.33.camel@localhost.localdomain>
	 <20081217205902.GH28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Wed, 17 Dec 2008 16:10:44 -0500
Message-Id: <1229548244.3384.49.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-17 at 20:59 +0000, Al Viro wrote:
> On Wed, Dec 17, 2008 at 01:28:08PM -0500, Eric Paris wrote:
> 
> > I don't see why prio is only important on AUDIT_FILTER_EXIT.  Couldn't I
> > end up with stupidity with entry,never  ?
> 
> 
> AUDIT_WATCH and AUDIT_INODE can live only on exit chain.  I.e. we don't have
> that problem - other chains sit on the lists of their own and there the
> list ordering itself takes care of everything.  Exit chain has parts in
> sitting in hash instead of the primary list.

Makes perfect sense.  They all look good to me.

-Eric

