Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbZBJRwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbZBJRwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 12:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbZBJRwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 12:52:09 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:39744 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbZBJRwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 12:52:06 -0500
Subject: Re: +
	powerpc-fix-code-for-reserved-memory-spanning-across-nodes.patch added to
	-mm tree
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       chandru@in.ibm.com, chandru@linux.vnet.ibm.com, paulus@samba.org,
       akpm@linux-foundation.org, Johannes Weiner <hannes@cmpxchg.org>,
       "Jon M. Tollefson [imap]" <kniht@us.ibm.com>
In-Reply-To: <1234139464.31963.79.camel@pasglop>
References: <200812250806.mBP86LPQ018399@imap1.linux-foundation.org>
	 <20090208204725.GA5514@cmpxchg.org>  <1234139464.31963.79.camel@pasglop>
Content-Type: text/plain
Date: Tue, 10 Feb 2009 09:51:50 -0800
Message-Id: <1234288310.30155.27.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-09 at 11:31 +1100, Benjamin Herrenschmidt wrote:
> Dave, you've had your hands in that code more than I did lately, do
> that
> look ok to you ?

I still think that patch is bogus.  I don't know how it is still around.
I described the problem pretty completely here:

http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4a6186696e7f15b3ea4dafcdb64ee0703e0e4487

Chandru effectively reverted my bugfix from that patch in this one.

> (BTW. On another note, do you still have pending bug fixes that didn't
> got in .29 ?)

No, I don't think so.  There were some distro fixes but I couldn't
reproduce the bugs on mainline.

-- Dave

