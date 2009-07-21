Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbZGUXfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbZGUXfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 19:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755551AbZGUXfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 19:35:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755502AbZGUXfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 19:35:46 -0400
Date: Tue, 21 Jul 2009 16:35:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
Cc: rdreier@cisco.com, benh@kernel.crashing.org, linux-kernel@vger.kernel.org
Subject: Re: lib: Export generic atomic64_t functions
Message-Id: <20090721163513.c4baa6b3.akpm@linux-foundation.org>
In-Reply-To: <19029.17220.326485.724846@cargo.ozlabs.ibm.com>
References: <ada63e221js.fsf@cisco.com>
	<19029.17220.326485.724846@cargo.ozlabs.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jul 2009 11:09:24 +1000
Paul Mackerras <paulus@samba.org> wrote:

> Roland Dreier writes:
> 
> > The generic atomic64_t implementation in lib/ did not export the
> > functions it defined, which means that modules that use atomic64_t
> > would not link on platforms (such as 32-bit powerpc).  For example,
> > trying to build a kernel with CONFIG_NET_RDS on such a platform would
> > fail with:
> > 
> >     ERROR: "atomic64_read" [net/rds/rds.ko] undefined!
> >     ERROR: "atomic64_set" [net/rds/rds.ko] undefined!
> > 
> > Fix this by exporting the atomic64_t functions to modules.  (I export
> > the entire API even if it's not all currently used by in-tree modules to
> > avoid having to continue fixing this in dribs and drabs)
> > 
> > Signed-off-by: Roland Dreier <rolandd@cisco.com>
> 
> Nice, thanks.
> 
> Acked-by: Paul Mackerras <paulus@samba.org>
> 
> Andrew, I think this should be safe to go in 2.6.31.  Could you
> include it in your next batch for Linus, or should I send it to him
> directly?
> 

Am still catching up, sorry.  Yup, I put this in my 2.6.31 queue.
