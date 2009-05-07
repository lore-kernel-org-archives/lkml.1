Return-Path: <linux-kernel-owner+w=401wt.eu-S1759401AbZEGXhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401AbZEGXhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 19:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758239AbZEGXhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 19:37:07 -0400
Received: from sh.osrg.net ([192.16.179.4]:46382 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756382AbZEGXhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 19:37:06 -0400
Date: Fri, 8 May 2009 08:35:21 +0900
To: jirislaby@gmail.com
Cc: yanghy@cn.fujitsu.com, akpm@linux-foundation.org,
       fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] remove DMA_nBIT_MASK macro
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4A029FD1.1050007@gmail.com>
References: <20090506223452.65e545d8.akpm@linux-foundation.org>
	<4A029BE1.4090309@cn.fujitsu.com>
	<4A029FD1.1050007@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090508083610Z.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 08 May 2009 08:35:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 May 2009 10:46:09 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> On 05/07/2009 10:29 AM, Yang Hongyang wrote:
> > Shall we use something like below to warn people?
> > #define DMA_64BIT_MASK	DMA_BIT_MASK(64);(__deprecated warnings:use DMA_BIT_MASK(64) instead) ?
> 
> Something like an irq flags deprecation in the past:
> http://lwn.net/Articles/229673/
> ?
> 
> I don't know how many in-initializer (struct x x = { DMA_64BIT_MASK } )
> users are out there though.

Unfortunately, there are lots. Converting these macros to functions
would breaks drivers too.
