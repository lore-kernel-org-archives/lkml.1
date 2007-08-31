Return-Path: <linux-kernel-owner+w=401wt.eu-S1763316AbXHaFRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763316AbXHaFRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 01:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758202AbXHaFR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 01:17:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40337 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756289AbXHaFR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 01:17:27 -0400
Date: Thu, 30 Aug 2007 22:16:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
cc: Frank van Maarseveen <frankvm@frankvm.com>, Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: recent nfs change causes autofs regression
In-Reply-To: <1188536658.6626.98.camel@heimdal.trondhjem.org>
Message-ID: <alpine.LFD.0.999.0708302215280.25853@woody.linux-foundation.org>
References: <000701c7eb49$cff701c0$6fe50540$@com>  <1188513433.6626.24.camel@heimdal.trondhjem.org>
  <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org> 
 <1188535485.6626.85.camel@heimdal.trondhjem.org> 
 <alpine.LFD.0.999.0708302157470.25853@woody.linux-foundation.org>
 <1188536658.6626.98.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 31 Aug 2007, Trond Myklebust wrote:
> 
> So you are saying that it is acceptable for the kernel to decide
> unilaterally to override mount options?

IT'S WHAT WE'VE APPARENTLY ALWAYS DONE!

> Why aren't we doing that for any other filesystem than NFS?

How hard is it to acknowledge the following little word:

	"regression"

It's simple. You broke things. You may want to fix them, but you need to 
fix them in a way that does not break user space.

		Linus
