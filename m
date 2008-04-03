Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbYDCXma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbYDCXma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 19:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbYDCXmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 19:42:23 -0400
Received: from ozlabs.org ([203.10.76.45]:37939 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbYDCXmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 19:42:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: PATCH [1/1]: Don't return symbol lables in init sections after they have been freed
Date: Fri, 4 Apr 2008 09:41:42 +1000
User-Agent: KMail/1.9.9
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
References: <200803041847.15884.rgetz@blackfin.uclinux.org> <200803051243.26732.rusty@rustcorp.com.au> <200804021801.25937.rgetz@blackfin.uclinux.org>
In-Reply-To: <200804021801.25937.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804040941.42275.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 April 2008 08:01:25 Robin Getz wrote:
> On Tue 4 Mar 2008 20:43, Rusty Russell pondered:
> >     As to the actual patch, your kallsyms.c patch matches
> > a2da4052f1df6bc77749f84496fe731ab8b458f7's change to extable.c: please
> > resubmit with just that one.  For bonus points, look at combining the
> > extable and kallsyms logic so we don't diverge in future...
>
> OK since this took so long, I went for bonus points...

Looks good.  I don't have extratext in my kernel tho 
(v2.6.25-rc8-139-ge315c12).  Otherwise I'd suspect it should be consistently 
used between extable and kallsyms.

Thanks!
Rusty.
