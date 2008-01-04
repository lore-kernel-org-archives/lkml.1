Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbYADSTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbYADSTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 13:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbYADSTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 13:19:31 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:43234 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342AbYADSTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 13:19:30 -0500
Message-ID: <477E78A5.2040404@oracle.com>
Date: Fri, 04 Jan 2008 10:19:17 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: bcrl@kvack.org, linux-aio@kvack.org, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aio: partial write should not return error code.
References: <200801032004.08907.rusty@rustcorp.com.au> <477D3FCE.6080005@oracle.com> <200801041410.24297.rusty@rustcorp.com.au>
In-Reply-To: <200801041410.24297.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> No, that's fine, here is the new one:
> 
> When an AIO write gets a non-retry error after writing some data
> (eg. ENOSPC), it should return the amount written already, not the
> error.  Just like write() is supposed to.
> 
> This was found by the libaio test suite.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

This looks good, feel free to push this from your tree.

Acked-By: Zach Brown <zach.brown@oracle.com>

- z
