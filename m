Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbYACURr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbYACURr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 15:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYACURk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 15:17:40 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:48807 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbYACURi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 15:17:38 -0500
Message-ID: <477D42D3.1060500@oracle.com>
Date: Thu, 03 Jan 2008 12:17:23 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: bcrl@kvack.org, linux-aio@kvack.org, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aio: negative offset should return -EINVAL
References: <200801032004.08907.rusty@rustcorp.com.au> <200801032004.44696.rusty@rustcorp.com.au>
In-Reply-To: <200801032004.44696.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> An AIO read or write should return -EINVAL if the offset is negative.
> This check matches the one in pread and pwrite.
> 
> This was found by the libaio test suite.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

This looks fine to me.

Signed-off-by: Zach Brown <zach.brown@oracle.com>

- z
