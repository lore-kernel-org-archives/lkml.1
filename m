Return-Path: <linux-kernel-owner+w=401wt.eu-S1758256AbYG2W4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbYG2W4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 18:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754269AbYG2W4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 18:56:47 -0400
Received: from namei.org ([69.55.235.186]:49888 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753579AbYG2W4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 18:56:46 -0400
Date: Wed, 30 Jul 2008 08:55:40 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       David Howells <dhowells@redhat.com>, Al Viro <viro@ftp.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT] New Credentials API (preliminary patches for 2.6.27)
 [updated]
In-Reply-To: <Xine.LNX.4.64.0807291043190.18657@us.intercode.com.au>
Message-ID: <Xine.LNX.4.64.0807300841430.10277@us.intercode.com.au>
References: <Xine.LNX.4.64.0807260543320.24288@us.intercode.com.au>
 <Xine.LNX.4.64.0807291043190.18657@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008, James Morris wrote:

> On Sat, 26 Jul 2008, James Morris wrote:
> 
> > A new credentials framework has been developed by David Howells.  The code 
> > has been through several iterations of posting and review, and is 
> > considered by various folk to be ready to merge into linux-next.
> 
> These patches have been updated by David to resolve conflicts in current 
> git, re-tested, and may be pulled cleanly per below.
> 

Linus,

Would you be able to provide some guidance on a strategy for getting these 
credentials changes merged?  I gather they've missed the boat for 2.6.27 
(although, they are now essentially reduced to API-level changes, and not 
as scary as they look).

Stephen is not keen on taking them in linux-next, as there'll be constant 
merge conflicts, and I'm not sure whether there'd be value in dropping 
them in at the end each day.

There seems to be two options at this stage:

1. Drop them into the front of linux-next and ask developers to maintain
trees against that.  Perhaps this is how API changes in general could 
happen?

2. Maintain them separately until the very start of the next merge window 
and get them in up front when it opens.

Thoughts?



- James
-- 
James Morris
<jmorris@namei.org>
