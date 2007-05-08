Return-Path: <linux-kernel-owner+w=401wt.eu-S967456AbXEHOeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967456AbXEHOeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 10:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968146AbXEHOeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 10:34:11 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50932 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967455AbXEHOeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 10:34:10 -0400
Date: Tue, 8 May 2007 17:34:08 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Rene Herman <rene.herman@gmail.com>
cc: Andrew Morton <akpm@osdl.org>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: New Mitsumi legacy CD-ROM driver
In-Reply-To: <46408662.5070003@gmail.com>
Message-ID: <Pine.LNX.4.64.0705081731100.32530@sbz-30.cs.Helsinki.FI>
References: <464045F0.3040906@gmail.com> <84144f020705080653i16d324c8pbd2925d844f400fc@mail.gmail.com>
 <46408662.5070003@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Rene Herman wrote:
> I admit my DOS inspired dislike of realloc() is largely pointless these days
> but, err... "E426: tag not found: krealloc". Would you perhaps like the list?
> Or the if (tracks != mcd->tracks) thing?

The krealloc() API has been in current git for few days now. I suggested 
it because I thought it would nicely fold the kfree() + kzalloc() pair 
into a simple krealloc() call but the error handling makes it a total 
mess. I think we need kzrealloc() in the kernel... ;-)

So please simply ignore my comment.

				Pekka
