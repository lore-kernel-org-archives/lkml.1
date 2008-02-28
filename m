Return-Path: <linux-kernel-owner+w=401wt.eu-S1760725AbYB1Q75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760725AbYB1Q75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 11:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbYB1Q7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 11:59:50 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:33197 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbYB1Q7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 11:59:49 -0500
Message-ID: <47C6E882.8000908@oracle.com>
Date: Thu, 28 Feb 2008 08:59:46 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: bcrl@kvack.org, linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fs/aio.c: make 3 functions static
References: <20080227212037.GJ29269@cs181133002.pp.htv.fi>
In-Reply-To: <20080227212037.GJ29269@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch makes the following needlessly global functions static:
> - __put_ioctx()

I think this is fine because we never exported it.  (And I shudder to
imagine what people would actually *do* with kioctx references outside
fs/aio.c.)

> - lookup_ioctx()
> - io_submit_one()

Both fine.

Acked-By: Zach Brown <zach.brown@oracle.com>

- z
