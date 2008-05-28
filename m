Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbYE1VwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbYE1VwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbYE1VwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:52:01 -0400
Received: from sous-sol.org ([216.99.217.87]:54838 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261AbYE1VwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:52:00 -0400
Date: Wed, 28 May 2008 14:51:07 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Chris Wright <chrisw@sous-sol.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: Redzone overwritten with CONFIG_SECURITY
Message-ID: <20080528215107.GJ30402@sequoia.sous-sol.org>
References: <20080526143422.GA3203@alice> <84144f020805270800l5911ed02ia7a92d96a8aa32a7@mail.gmail.com> <20080527174738.GZ30402@sequoia.sous-sol.org> <20080528100357.GA2510@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080528100357.GA2510@alice>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Sesterhenn (snakebyte@gmx.de) wrote:
> Is it possible that this was caused because a file didnt
> get rebuild correctly? I can still reproduce it with the
> old checkout. Sorry if this causes unessecary noise :(

I had wondered that, since data structures will grow w/ CONFIG_SECURITY
set (like inode, for example).  I haven't encountered a Kbuild dependency
bug in quite a while though.

thanks,
-chris
