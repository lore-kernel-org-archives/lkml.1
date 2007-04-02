Return-Path: <linux-kernel-owner+w=401wt.eu-S965378AbXDBKXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965378AbXDBKXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 06:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965379AbXDBKXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 06:23:22 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53038 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965378AbXDBKXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 06:23:21 -0400
Date: Mon, 2 Apr 2007 13:23:19 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Johannes Weiner <hannes-kernel@saeurebad.de>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       christoph@lameter.com
Subject: Re: [PATCH] Catch kmalloc() failure in kmem_cache_init()
In-Reply-To: <20070402101813.GB5831@saeurebad.de>
Message-ID: <Pine.LNX.4.64.0704021320100.29898@sbz-30.cs.Helsinki.FI>
References: <20070329160434.GA10265@cvg> <20070402101813.GB5831@saeurebad.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007, Johannes Weiner wrote:
> This patch makes kmem_cache_init() trigger a BUG when the calls to
> kmalloc() fail. Altough the kernel would not boot anyway on failure,
> this adds some clarity to the code.

Indeed. This keeps popping up again and again, so

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
