Return-Path: <linux-kernel-owner+w=401wt.eu-S1761934AbYDSXdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761934AbYDSXdw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 19:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbYDSXdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 19:33:42 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:60691 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbYDSXdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 19:33:41 -0400
Date: Sat, 19 Apr 2008 16:33:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, Josh Triplett <josh@freedesktop.org>,
       linux-wireless@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [RFC 0/3] Examples for the new sparse context tracking functionality
Message-ID: <20080419233338.GG20138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080410134810.629048000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410134810.629048000@sipsolutions.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 03:48:10PM +0200, Johannes Berg wrote:
> Here are some patches that show how the new sparse functionality  
> could be used in the kernel if merged.
> 
> As mentioned before, I have actually found three bugs in mac80211
> using these patches. If you apply them and the sparse patches I have
> also just posted, you can find them too :)

I like this approach in general, deferring to Josh on specifics.

At some point in the future, we might want to distinguish between
the different flavors of RCU -- except that there is already common
code that doesn't care which flavor of RCU is in use, as long as
some sort of RCU is present.  So make that "some point in the distant
future"...

						Thanx, Paul
