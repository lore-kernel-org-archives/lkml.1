Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbYHNEPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbYHNEPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 00:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYHNEPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 00:15:08 -0400
Received: from ozlabs.org ([203.10.76.45]:32858 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895AbYHNEPG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 00:15:06 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Fernando Luis =?utf-8?q?V=C3=A1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
Subject: Re: request->ioprio
Date: Thu, 14 Aug 2008 12:16:33 +1000
User-Agent: KMail/1.9.9
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       =?utf-8?q?=E5=90=89=E5=B7=9D_=E6=8B=93=E5=93=89?= 
	<yoshikawa.takuya@oss.ntt.co.jp>,
       dpshah@google.com
References: <1218014196.4419.44.camel@sebastian.kern.oss.ntt.co.jp> <200808070633.06112.rusty@rustcorp.com.au> <1218611163.8001.108.camel@sebastian.kern.oss.ntt.co.jp>
In-Reply-To: <1218611163.8001.108.camel@sebastian.kern.oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808141216.33688.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 August 2008 17:06:03 Fernando Luis Vázquez Cao wrote:
> Besides, I guess that accessing the io context information (such as
> ioprio) of a request through elevator-specific private structures is not
> something we want virtio_blk (or future users) to do.

The only semantic I assumed was "higher is better".  The server (ie. host) can 
really only use the information to schedule between I/Os for that particular 
guest anyway.

But it sounds like I should be passing "0" in there unconditionally until the 
kernel semantics are sorted out and I can do something more intelligent?  I 
haven't checked, but I assume that's actually what's happening at the moment 
(the field is zero)?

Rusty.
