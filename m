Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbYHPHNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbYHPHNw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 03:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbYHPHNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 03:13:43 -0400
Received: from ozlabs.org ([203.10.76.45]:35824 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbYHPHNn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 03:13:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Fernando Luis =?utf-8?q?V=C3=A1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
Subject: Re: request->ioprio
Date: Sat, 16 Aug 2008 17:13:36 +1000
User-Agent: KMail/1.9.9
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       =?utf-8?q?=E5=90=89=E5=B7=9D_=E6=8B=93=E5=93=89?= 
	<yoshikawa.takuya@oss.ntt.co.jp>,
       dpshah@google.com
References: <1218014196.4419.44.camel@sebastian.kern.oss.ntt.co.jp> <200808141216.33688.rusty@rustcorp.com.au> <1218779462.5291.59.camel@sebastian.kern.oss.ntt.co.jp>
In-Reply-To: <1218779462.5291.59.camel@sebastian.kern.oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808161713.37146.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 August 2008 15:51:02 Fernando Luis Vázquez Cao wrote:
> On Thu, 2008-08-14 at 12:16 +1000, Rusty Russell wrote:
> > On Wednesday 13 August 2008 17:06:03 Fernando Luis Vázquez Cao wrote:
> > > Besides, I guess that accessing the io context information (such as
> > > ioprio) of a request through elevator-specific private structures is
> > > not something we want virtio_blk (or future users) to do.
> >
> > The only semantic I assumed was "higher is better".  The server (ie.
> > host) can really only use the information to schedule between I/Os for
> > that particular guest anyway.
>
> Does that mean you are not going to incorporate the prio class system
> that is used in Linux?

Actually, since it's unused at the moment, we can define it however we want.  
But note that this is an ABI; while the kernel-internal definitions are 
fluid, this semantic must stay the same (even if the actual values differ).

So we should probably put an explicit mapping function there anyway.

Thanks,
Rusty.
