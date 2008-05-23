Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbYEWBVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbYEWBVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 21:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbYEWBU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 21:20:26 -0400
Received: from beauty.rexursive.com ([203.171.74.242]:54063 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbYEWBUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 21:20:23 -0400
Subject: Re: capget() overflows buffers.
From: Bojan Smojver <bojan@rexursive.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Dave Jones <davej@codemonkey.org.uk>, Andrew Morgan <morgan@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080522205341.GA30402@sequoia.sous-sol.org>
References: <20080522140402.GB2071@codemonkey.org.uk>
	 <20080522175744.GE4018@sequoia.sous-sol.org>
	 <20080522205341.GA30402@sequoia.sous-sol.org>
Content-Type: text/plain
Date: Fri, 23 May 2008 11:20:22 +1000
Message-Id: <1211505622.20341.6.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-22 at 13:53 -0700, Chris Wright wrote:

>     cap_user_header_t head = (cap_user_header_t) xcalloc(1, sizeof(cap_user_header_t));
>     cap_user_data_t cap = (cap_user_data_t) xcalloc(1, sizeof(cap_user_data_t));

BTW, both of the above allocations have been fixed in Squid 2 & 3, as
they were incorrect. Not sure how that worked before - probably by
accident.

http://www.squid-cache.org/bzrview/squid3/trunk/changes?q=9001

-- 
Bojan

