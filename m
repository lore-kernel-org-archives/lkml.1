Return-Path: <linux-kernel-owner+w=401wt.eu-S1761048AbXHaFCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761048AbXHaFCG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 01:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757518AbXHaFB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 01:01:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60241 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754414AbXHaFBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 01:01:55 -0400
Date: Thu, 30 Aug 2007 21:59:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
cc: Frank van Maarseveen <frankvm@frankvm.com>, Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: recent nfs change causes autofs regression
In-Reply-To: <1188535485.6626.85.camel@heimdal.trondhjem.org>
Message-ID: <alpine.LFD.0.999.0708302157470.25853@woody.linux-foundation.org>
References: <000701c7eb49$cff701c0$6fe50540$@com>  <1188513433.6626.24.camel@heimdal.trondhjem.org>
  <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org>
 <1188535485.6626.85.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 31 Aug 2007, Trond Myklebust wrote:
> 
> It did not. The previous behaviour was to always silently override the
> user mount options.

..so it still worked for any sane setup, at least.

You broke that. Hua gave good reasons for why he cannot use the current 
kernel. It's a regression.

In other words, the new behaviour is *worse* than the behaviour you 
consider to be the incorrect one.

		Linus
