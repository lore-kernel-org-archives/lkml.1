Return-Path: <linux-kernel-owner+w=401wt.eu-S1161294AbXCBALW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161294AbXCBALW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 19:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161304AbXCBALW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 19:11:22 -0500
Received: from smtp.osdl.org ([65.172.181.24]:57249 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161294AbXCBALV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 19:11:21 -0500
Date: Thu, 1 Mar 2007 16:11:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scatterlist.h needs types.h
Message-Id: <20070301161106.5687156e.akpm@linux-foundation.org>
In-Reply-To: <20070301135516.5e6b6b29.khali@linux-fr.org>
References: <20070301135516.5e6b6b29.khali@linux-fr.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2007 13:55:16 +0100
Jean Delvare <khali@linux-fr.org> wrote:

> Most architectures' scatterlist.h use the type dma_addr_t, but omit
> to include <asm/types.h> which defines it. This could lead to build
> failures, so let's add the missing includes.

_does_ it actually lead to build errors?  If so, 2.6.21.  If not, 2.6.22.
