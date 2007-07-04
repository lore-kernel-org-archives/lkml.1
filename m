Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbXGDDdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbXGDDdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 23:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbXGDDc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 23:32:57 -0400
Received: from canuck.infradead.org ([209.217.80.40]:48062 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbXGDDc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 23:32:56 -0400
Subject: Re: [PATCH] Re: Sparc32: random invalid instruction occourances on
	sparc32 (sun4c)
From: David Woodhouse <dwmw2@infradead.org>
To: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Christoph Lameter <clameter@engr.sgi.com>,
       William Lee Irwin III <wli@holomorphy.com>
In-Reply-To: <Pine.LNX.4.61.0707040335230.30946@mtfhpc.demon.co.uk>
References: <468A7D14.1050505@googlemail.com>
	 <Pine.LNX.4.61.0707031817050.29930@mtfhpc.demon.co.uk>
	 <Pine.LNX.4.61.0707031910280.29930@mtfhpc.demon.co.uk>
	 <1183490778.29081.35.camel@shinybook.infradead.org>
	 <Pine.LNX.4.61.0707032209230.30376@mtfhpc.demon.co.uk>
	 <1183499781.29081.46.camel@shinybook.infradead.org>
	 <Pine.LNX.4.61.0707032317590.30376@mtfhpc.demon.co.uk>
	 <1183505787.29081.62.camel@shinybook.infradead.org>
	 <Pine.LNX.4.61.0707040335230.30946@mtfhpc.demon.co.uk>
Content-Type: text/plain
Date: Tue, 03 Jul 2007 23:33:25 -0400
Message-Id: <1183520006.29081.79.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-04 at 04:27 +0100, Mark Fortescue wrote:
> I tried the previous patch and it looks like it fixes the issue however 
> one of the test builds I did caused depmod to use up all available memory 
> (40M - kernel memory) before taking out the kernel with the oom killer.
> At present, I do not know if it is a depmod issue or a kernel issue.
> I will have to do some more tests later on to day.

That's almost certain to be an unrelated issue.

> I have looked at the latest patch below and am I am still not sure about 
> two areas. Please take a look at my offering based on your latest 
> patch (included here to it will probably get mangled).
> 
> Note the change to lines 2178 to 2185. I have also changed/moved the 
> alignment of size (see lines 2197 to 2206) based on your changes. 

The first looks correct; well spotted. The second is just cosmetic but
also seems correct. I might be inclined to make the #define
'RED_ZONE_ALIGN' and use it in the other places too.

-- 
dwmw2

