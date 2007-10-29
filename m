Return-Path: <linux-kernel-owner+w=401wt.eu-S1760120AbXJ2S6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760120AbXJ2S6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 14:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbXJ2S6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 14:58:09 -0400
Received: from brick.kernel.dk ([87.55.233.238]:23563 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbXJ2S6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 14:58:09 -0400
Date: Mon, 29 Oct 2007 19:58:04 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gorcunov@gmail.com
Subject: Re: [PATCH] Clean up scatterlist.h and introduce macros for readability.
Message-ID: <20071029185803.GA7499@kernel.dk>
References: <Pine.LNX.4.64.0710291234560.20259@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710291234560.20259@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29 2007, Robert P. J. Day wrote:
> 
> Add some macros to <linux/scatterlist.h> to make the bit manipulation
> more readable, and expand on some of the documentation.
> 
> This patch incorporates content from Cyrill Gorcunov
> <gorcunov@gmail.com> as well.

I don't like it, I already explained why I don't consider the 'magic'
values a problem. The use of the bits is supposed to be scatterlist.h
private and the values are documented at the top of that include file.

-- 
Jens Axboe

