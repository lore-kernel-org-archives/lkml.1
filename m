Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbYGHNFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbYGHNFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 09:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbYGHNE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 09:04:59 -0400
Received: from ozlabs.org ([203.10.76.45]:33821 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731AbYGHNE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 09:04:57 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] CONFIG_KMOD needs to be default y
Date: Tue, 8 Jul 2008 23:03:25 +1000
User-Agent: KMail/1.9.9
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Tomas Winkler <tomasw@gmail.com>
References: <1215517771.9610.28.camel@johannes.berg> <20080708124208.GA6704@infradead.org>
In-Reply-To: <20080708124208.GA6704@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807082303.26194.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 July 2008 22:42:08 Christoph Hellwig wrote:
> On Tue, Jul 08, 2008 at 01:49:31PM +0200, Johannes Berg wrote:
> > Far too many people configure their kernel without CONFIG_KMOD
> > and then complain that wireless breaks, thanks to Herbert Xu for
> > pointing me to this.
> >
> > This patch makes CONFIG_KMOD default to "y" and adds a warning
> > that people should not turn it off.
>
> What about just killing the config option entirely?  It' basically
> guarding a ~50 lines function + a sysctl variable.  I think having
> modules but not CONFIG_KMOD is entirely unreasonable.

I agree with Christoph here.

But as a patch series please: it's spread pretty wide.  eg. first make it a 
non-prompting CONFIG option, then remove the users, then finally kill it.

Some existing request_module users might be able to use 
try_then_request_module, too...

Thanks!
Rusty.
