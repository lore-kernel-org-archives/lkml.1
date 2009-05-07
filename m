Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbZEGI6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbZEGI6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 04:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbZEGI6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 04:58:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56127 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755419AbZEGI6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 04:58:07 -0400
Message-ID: <4A02A2D8.4090209@cn.fujitsu.com>
Date: Thu, 07 May 2009 16:59:04 +0800
From: Yang Hongyang <yanghy@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] remove DMA_nBIT_MASK macro
References: <20090507141114M.fujita.tomonori@lab.ntt.co.jp> <20090506223452.65e545d8.akpm@linux-foundation.org> <4A029BE1.4090309@cn.fujitsu.com> <4A029FD1.1050007@gmail.com>
In-Reply-To: <4A029FD1.1050007@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 05/07/2009 10:29 AM, Yang Hongyang wrote:
>> Shall we use something like below to warn people?
>> #define DMA_64BIT_MASK	DMA_BIT_MASK(64);(__deprecated warnings:use DMA_BIT_MASK(64) instead) ?
> 
> Something like an irq flags deprecation in the past:
> http://lwn.net/Articles/229673/
> ?

good catch,but this need to be modified (add one line is enough)to cause their use to
cause __deprecated warnings.

> 
> I don't know how many in-initializer (struct x x = { DMA_64BIT_MASK } )
> users are out there though.
> 
> 


-- 
Regards
Yang Hongyang
