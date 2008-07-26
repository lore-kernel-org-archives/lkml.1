Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbYGZSbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbYGZSbQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 14:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbYGZSbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 14:31:00 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:41118 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbYGZSbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 14:31:00 -0400
Date: Sat, 26 Jul 2008 20:30:34 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] linux/swap.h must #include <linux/pagemap.h>
Message-ID: <20080726203034.456e7678@siona.local>
In-Reply-To: <20080726173832.GE9301@cs181140183.pp.htv.fi>
References: <1217092685-15267-1-git-send-email-haavard.skinnemoen@atmel.com>
	<20080726173832.GE9301@cs181140183.pp.htv.fi>
Organization: Atmel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jul 2008 18:30:33.0484 (UTC) FILETIME=[B09FC4C0:01C8EF4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jul 2008 20:38:32 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> The patch is not the correct fix since the actual problem comes from 
> free_pages_and_swap_cache() in swap.h

True, but I saw this comment in swap.h:

/* only sparc can not include linux/pagemap.h in this file
 * so leave page_cache_release and release_pages undeclared... */

so I thought it might be safer to add the include to tlb.h instead.

Haavard
