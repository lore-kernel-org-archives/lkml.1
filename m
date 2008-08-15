Return-Path: <linux-kernel-owner+w=401wt.eu-S1757014AbYHOFer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbYHOFer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 01:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbYHOFei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 01:34:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55904 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbYHOFeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 01:34:37 -0400
Date: Fri, 15 Aug 2008 06:34:36 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
Message-ID: <20080815053436.GD28946@ZenIV.linux.org.uk>
References: <20080812062241.GQ28946@ZenIV.linux.org.uk> <87ej4u9nf5.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <20080812181057.GR28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121316570.3462@nehalem.linux-foundation.org> <20080812203808.GV28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121351570.3462@nehalem.linux-foundation.org> <20080813000433.GZ28946@ZenIV.linux.org.uk> <20080815050613.GJ4422@cs.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815050613.GJ4422@cs.cmu.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 01:06:13AM -0400, Jan Harkes wrote:
> On Wed, Aug 13, 2008 at 01:04:33AM +0100, Al Viro wrote:
> > coda:	returns fsck knows what (number of entries, mostly)
> 
> Not sure either and I was the one that sent the patch that introduced
> that. My closest guess would be that I looked too long at a getdents(2)
> manpage, but then again it doesn't really match that either.

Simply return 0 unless you get an error in iterator itself.  Returning the
first error from filldir requires changes in callers.
