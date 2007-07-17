Return-Path: <linux-kernel-owner+w=401wt.eu-S1765666AbXGQHE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765666AbXGQHE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 03:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761862AbXGQHEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 03:04:31 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42694 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759093AbXGQHEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 03:04:30 -0400
Date: Tue, 17 Jul 2007 10:04:28 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Akinobu Mita <akinobu.mita@gmail.com>
cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/10] sysfs: fix kmem_cache_free(NULL)
In-Reply-To: <961aa3350707160953y2c50ce44j5fb7fd8559120bae@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707171003050.1297@sbz-30.cs.Helsinki.FI>
References: <20070716134855.GA1858@APFDCB5C> <20070716135028.GA2040@APFDCB5C>
  <20070716154335.GA29449@suse.de> <961aa3350707160953y2c50ce44j5fb7fd8559120bae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/7/17, Greg KH <gregkh@suse.de>:
> > Why not just allow kmem_cache_free() to allow NULL like other functions
> > in the kernel?

On Tue, 17 Jul 2007, Akinobu Mita wrote:
> It seems there was discussion about this and no conclusion
> yet?
 
IIRC the patch was rejected by relevant maintainers because it slows 
down kmem_cache_free() which is presumably bad for some hot-paths...

				Pekka
