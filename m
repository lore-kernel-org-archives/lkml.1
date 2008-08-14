Return-Path: <linux-kernel-owner+w=401wt.eu-S1753599AbYHNFRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbYHNFRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 01:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYHNFRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 01:17:14 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:42996 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbYHNFRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 01:17:13 -0400
Subject: Re: [PATCH] virtio_blk: use a wrapper function to access io
	context information of IO requests
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       =?UTF-8?Q?=E5=90=89=E5=B7=9D_=E6=8B=93=E5=93=89?= 
	<yoshikawa.takuya@oss.ntt.co.jp>,
       dpshah@google.com
In-Reply-To: <200808141442.09633.rusty@rustcorp.com.au>
References: <1218014196.4419.44.camel@sebastian.kern.oss.ntt.co.jp>
	 <1218611163.8001.108.camel@sebastian.kern.oss.ntt.co.jp>
	 <1218615271.16667.38.camel@sebastian.kern.oss.ntt.co.jp>
	 <200808141442.09633.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=utf-8
Organization: NTT Open Source Software Center
Date: Thu, 14 Aug 2008 14:17:11 +0900
Message-Id: <1218691031.31285.20.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-14 at 14:42 +1000, Rusty Russell wrote:
> On Wednesday 13 August 2008 18:14:31 Fernando Luis Vázquez Cao wrote:
> > Rusty, Jens
> >
> > What do you think about the patch below? Does it make sense?
> 
> Yes.  Obviously it makes more sense for Jens to queue this so:
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thank you Rusty. I'll be responding to this email with an updated patch
because I noticed the function I introduced is misnamed (it should be
req_get_ioprio() not req_get_bio()).

