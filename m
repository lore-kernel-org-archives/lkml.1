Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbYAYB3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbYAYB3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 20:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYAYB3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 20:29:32 -0500
Received: from ozlabs.org ([203.10.76.45]:47272 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbYAYB3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 20:29:31 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] Linux Kernel Markers Support for Proprierary Modules
Date: Fri, 25 Jan 2008 12:27:22 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jon Masters <jcm@redhat.com>
References: <1201029235.18144.62.camel@perihelion> <1201155569.25284.88.camel@perihelion> <20080124124703.GB32559@Krystal>
In-Reply-To: <20080124124703.GB32559@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801251227.22958.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 January 2008 23:47:04 Mathieu Desnoyers wrote:
> There seems to be good arguments for markers to support proprierary
> modules.

My attitude to this is simple: who cares about proprietary modules?

The current test is wrong, it should be checking for forced module loads 
(which may not have marker information and may well crash the kernel).  Of 
course, all forced module loads can crash the kernel, but this is pretty 
certain and it's simply to avoid.

We should just flat-out refuse to load a module with a module section too 
small.  That will cover the majority of this case anyway (*and* the 
non-kallsysms case), and then we can remove this test altogether.

Cheers,
Rusty.
