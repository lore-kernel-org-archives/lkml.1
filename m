Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbYCTFgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbYCTFgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 01:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbYCTFg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 01:36:26 -0400
Received: from ozlabs.org ([203.10.76.45]:56253 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbYCTFgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 01:36:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 4/4] Markers Support for Proprierary Modules
Date: Thu, 20 Mar 2008 16:35:30 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jon Masters <jcm@jonmasters.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jon Masters <jcm@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080320002737.918213455@polymtl.ca> <20080320002835.384758480@polymtl.ca>
In-Reply-To: <20080320002835.384758480@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803201635.30795.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 March 2008 11:27:41 Mathieu Desnoyers wrote:
> There seems to be good arguments for markers to support proprierary
> modules. So I am throwing this one-liner in and let's see how people react.
> It only makes sure that a module that has been "forced" to be loaded won't
> have its markers used. It is important to leave this check to make sure the
> kernel does not crash by expecting the markers part of the struct module by
> mistake in the case there is an incorrect checksum.

OK, I've applied this to my tree.  That means it will be in 2.6.26 unless you 
want me to push it earlier.

Thanks,
Rusty.
