Return-Path: <linux-kernel-owner+w=401wt.eu-S1759233AbXEaXMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233AbXEaXMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 19:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbXEaXMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 19:12:14 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753151AbXEaXMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 19:12:13 -0400
Date: Thu, 31 May 2007 16:12:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [2/4] 2.6.22-rc3: known regressions
In-Reply-To: <20070531155018.a8226075.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0705311610440.26602@woody.linux-foundation.org>
References: <465C188F.9000900@googlemail.com> <465C22F4.8080505@googlemail.com>
 <alpine.LFD.0.98.0705301918450.26602@woody.linux-foundation.org>
 <20070531220833.GA10867@beardog.cca.cpqcorp.net>
 <alpine.LFD.0.98.0705311516350.26602@woody.linux-foundation.org>
 <20070531223908.GA12325@beardog.cca.cpqcorp.net>
 <20070531155018.a8226075.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 31 May 2007, Andrew Morton wrote:
> 
> The status is "sitting in my queue for 2.6.22".  I'll be sending it up
> today or tomorrow.  Was hoping to get an ack from Greg &/| Andi on it, but
> those are not easy to come by.

Well, it looks "Obviously Correct(tm)", since clearly the iounmap() should 
be done _after_ the last use. So I don't think it needs any more acking.

But tomorrow is fine..

		Linus
