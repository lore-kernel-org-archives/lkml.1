Return-Path: <linux-kernel-owner+w=401wt.eu-S933027AbYGQVYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933027AbYGQVYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 17:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbYGQVYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 17:24:08 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:53633 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbYGQVYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 17:24:05 -0400
Date: Thu, 17 Jul 2008 14:20:38 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git patches] Ocfs2 and Configfs updates for 2.6.27
Message-ID: <20080717212038.GA8283@ca-server1.us.oracle.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Fasheh <mfasheh@suse.com>, linux-kernel@vger.kernel.org,
	ocfs2-devel@oss.oracle.com,
	Andrew Morton <akpm@linux-foundation.org>
References: <20080717175146.GH28014@wotan.suse.de> <alpine.LFD.1.10.0807171056520.2959@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807171056520.2959@woody.linux-foundation.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 11:01:40AM -0700, Linus Torvalds wrote:
> .. I really dislike how this was done.

	Argh!

> This commit:
> 
> 11c3b79218390a139f2d474ee1e983a672d5839a ("configfs: Allow ->make_item() 
> and ->make_group() to return detailed errors.")
> 
> is just ugly. Returning one value by passing a pointer to a pointer, and 
> the error value by returning an 'int' errno is _not_ how we do things in 
> the kernel.

	See, I coded it up with PTR_ERR() first, and everyone I showed
it to said "I hate PTR_ERR()!".

> I pulled it, but I want to register my protest.

	I wish you hadn't, because it won't be to difficult to go back
to PTR_ERR().  However, don't revert it - that affects some of the
follow-on patches that were affected by the change.
	I'll spin up a new PTR_ERR() change.  I have some more cleanups
coming too, they need to finish their time in linux-next.

Joel

-- 

"The cynics are right nine times out of ten."  
        - H. L. Mencken

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
