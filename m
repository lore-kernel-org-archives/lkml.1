Return-Path: <linux-kernel-owner+w=401wt.eu-S1758377AbXEJG4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377AbXEJG4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 02:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755811AbXEJG4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 02:56:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34731 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbXEJG4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 02:56:40 -0400
Date: Thu, 10 May 2007 07:56:36 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [patch 06/10] Linux Kernel Markers - Non optimized architectures
Message-ID: <20070510065636.GB8019@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070510015555.973107048@polymtl.ca> <20070510020916.836290342@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510020916.836290342@polymtl.ca>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 09:56:01PM -0400, Mathieu Desnoyers wrote:
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-arm/marker.h	2007-05-09 18:16:05.000000000 -0400
> @@ -0,0 +1,13 @@
> +/*
> + * marker.h

I think I've told you a few times already that mentioning the filename
in the file is pretty braindead and not exactly helpful.

Would be good to have an automatic check for this as I'm getting a little
tired of mentioning this three times a day.

> + *
> + * Code markup for dynamic and static tracing. Architecture specific
> + * optimisations.
> + *
> + * No optimisation implemented.
> + *
> + * This file is released under the GPLv2.
> + * See the file COPYING for more details.
> + */
> +
> +#include <asm-generic/marker.h>

I don't think any kind of copyright statement or comment is appopinquate
for a file that does nothing but including an asm-generic header.  This
file should a single line, namely:

#include <asm-generic/marker.h>

