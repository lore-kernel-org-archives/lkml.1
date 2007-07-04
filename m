Return-Path: <linux-kernel-owner+w=401wt.eu-S1762273AbXGDOpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762273AbXGDOpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 10:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760241AbXGDOpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 10:45:34 -0400
Received: from canuck.infradead.org ([209.217.80.40]:50416 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758422AbXGDOpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 10:45:33 -0400
Subject: Re: [PATCH] Re: Sparc32: random invalid instruction occourances on
	sparc32 (sun4c)
From: David Woodhouse <dwmw2@infradead.org>
To: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Christoph Lameter <clameter@engr.sgi.com>,
       William Lee Irwin III <wli@holomorphy.com>
In-Reply-To: <Pine.LNX.4.61.0707041121290.31752@mtfhpc.demon.co.uk>
References: <468A7D14.1050505@googlemail.com>
	 <Pine.LNX.4.61.0707031817050.29930@mtfhpc.demon.co.uk>
	 <Pine.LNX.4.61.0707031910280.29930@mtfhpc.demon.co.uk>
	 <1183490778.29081.35.camel@shinybook.infradead.org>
	 <Pine.LNX.4.61.0707032209230.30376@mtfhpc.demon.co.uk>
	 <1183499781.29081.46.camel@shinybook.infradead.org>
	 <Pine.LNX.4.61.0707032317590.30376@mtfhpc.demon.co.uk>
	 <1183505787.29081.62.camel@shinybook.infradead.org>
	 <Pine.LNX.4.61.0707040335230.30946@mtfhpc.demon.co.uk>
	 <1183520006.29081.79.camel@shinybook.infradead.org>
	 <Pine.LNX.4.61.0707041121290.31752@mtfhpc.demon.co.uk>
Content-Type: text/plain
Date: Wed, 04 Jul 2007 10:46:03 -0400
Message-Id: <1183560364.29081.106.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-04 at 11:27 +0100, Mark Fortescue wrote:
> Another related point that may also need to be considered is that I think 
> I am correct in saying that on ARM and on the 64bit platforms, sizeof 
> (unsigned long long) is 16 (128bits).

No, it's always 64 bits.

> Should the RedZone words be specified as __u64 not the unsigned long long 
> used or does the alignment need to be that of unsigned long long ?

You have to play silly buggers with printk formats (%lx vs. %llx) if you
do that. And you have to make a choice about using proper C types or the
Linux-specific nonsense. 'unsigned long long' is just easier all round.

-- 
dwmw2

