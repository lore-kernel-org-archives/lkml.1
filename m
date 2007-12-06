Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbXLFFKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbXLFFKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 00:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750906AbXLFFKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 00:10:09 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:58850 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbXLFFKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 00:10:07 -0500
Date: Wed, 5 Dec 2007 21:07:34 -0800
From: Brandon Philips <brandon@ifup.org>
To: Daniel Drake <dsd@gentoo.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation about unaligned memory access
Message-ID: <20071206050734.GA27132@ifup.org>
References: <20071203161101.A63469D4ED7@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203161101.A63469D4ED7@zog.reactivated.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:11 Mon 03 Dec 2007, Daniel Drake wrote:
> Here's a document I wrote after figuring out what unaligned memory access
> is all about. I've tried to cover the information I was looking for when
> trying to learn about this, without producing a hopelessly detailed/complex
> spew. I hope it is useful to others.
> 
> Signed-off-by: Daniel Drake <dsd@gentoo.org>
> 
> ---
<snip>
> +These macros work work for memory accesses of any length (not just 32 bits as

Remove a "work" here.

> +in the examples above). Be aware that when compared to standard access of
> +aligned memory, using these macros to access unaligned memory can be costly in
> +terms of performance.
> +
> +If use of such macros is not convenient, another option is to use memcpy(),
> +where the source or destination (or both) are of type u8* or unsigned char*.
> +Due to the byte-wise nature of this operation, unaligned accesses are avoided.

Cheers,

	Brandon
