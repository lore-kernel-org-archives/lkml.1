Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbZAJGTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbZAJGTP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 01:19:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbZAJGSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 01:18:48 -0500
Received: from ozlabs.org ([203.10.76.45]:58574 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbZAJGSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 01:18:47 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for January 8 (percpu)
Date: Sat, 10 Jan 2009 16:48:31 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
References: <20090108171730.19a41e14.sfr@canb.auug.org.au> <496636AB.9000903@oracle.com> <20090109092322.fd43b3b6.sfr@canb.auug.org.au>
In-Reply-To: <20090109092322.fd43b3b6.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901101648.32757.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 January 2009 08:53:22 Stephen Rothwell wrote:
> (Forward to Rusty)
> 
> On Thu, 08 Jan 2009 09:23:55 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >
> > Stephen Rothwell wrote:
> > > Hi all,
> > > 
> > > Changes since 20090107:
> > > 
> > > Undropped tree:
> > > 	rr
> > > 
> > > Dropped trees (temporarily):
> > > 	ocfs2 (build problem)
> > > 	cpu_alloc (build problem)
> > 
> > 
> > When CONFIG_SMP=n, both arch/x86/include/asm/percpu.h and
> > include/asm-generic/percpu.h define both of
> > read_percpu_ptr() and read_percpu_var().

Erk... this header is a bit of a mess of 64bit/32bit UP/SMP defines.

I've thwacked it harder, thanks!
Rusty.
