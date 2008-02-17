Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbYBQUjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbYBQUjM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:39:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbYBQUi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:38:58 -0500
Received: from relay2.sgi.com ([192.48.171.30]:40546 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752510AbYBQUi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:38:57 -0500
Date: Sun, 17 Feb 2008 14:38:51 -0600
From: Paul Jackson <pj@sgi.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: tilman@imap.cc, elendil@planet.nl, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: Unable to continue testing of 2.6.25
Message-Id: <20080217143851.c21a9cc4.pj@sgi.com>
In-Reply-To: <20080217194447.GD1403@cs181133002.pp.htv.fi>
References: <200802171025.30590.elendil@planet.nl>
	<20080217131611.GA1403@cs181133002.pp.htv.fi>
	<47B88A08.2070902@imap.cc>
	<20080217194447.GD1403@cs181133002.pp.htv.fi>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian wrote:
> So let's fix the problem (kernel lacks functionality)

That's the problem as understood by Adrian.

I hear another problem as well ... 

Frans wrote:
> Please allow external users some decent period for transitioning. The 
> initial plan to "remove the old function in 2.6.27" was entirely sensible. 
> It's a pity it was not followed through.

That seems plain enough to me.  It's not just the lack of functionality,
but that such lack apparently happened with too little warning.

If this is a fair representation of what happened, then seems to me that
we could have left that EXPORT_UNUSED_SYMBOL(change_page_attr) in place
a bit longer.

Or at least, if we really did have to make Frans life difficult like
this, we could offer more appreciation for how things might look from
his perspective.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
