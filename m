Return-Path: <linux-kernel-owner+w=401wt.eu-S933283AbYBTQlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933283AbYBTQlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934838AbYBTQbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:31:45 -0500
Received: from linode.ducksong.com ([64.22.125.164]:48568 "EHLO
	linode.ducksong.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934834AbYBTQbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:31:43 -0500
Subject: Re: [PATCH] splice: fix problem with sys_tee and SPLICE_F_NONBLOCK
From: Patrick McManus <mcmanus@ducksong.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Johann Felix Soden <johfel@gmx.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20080220093528.GU23197@kernel.dk>
References: <1203452091.7758.5.camel@localhost>
	 <20080219202543.GK23197@kernel.dk> <1203455538.7758.17.camel@localhost>
	 <20080219212530.GN23197@kernel.dk> <1203457661.7758.31.camel@localhost>
	 <20080220093528.GU23197@kernel.dk>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 11:31:51 -0500
Message-Id: <1203525111.5949.100.camel@tng>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2008-02-20 at 10:35 +0100, Jens Axboe wrote:

> When non-blocking is set, ideally we want to return 0 if there's no hope
> of anymore data and EAGAIN if trying later may yield some data. So how
> about this instead?
> 


Thank you Jens and Johann.

-Patrick


