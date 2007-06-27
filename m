Return-Path: <linux-kernel-owner+w=401wt.eu-S1761030AbXF0HjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761030AbXF0HjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 03:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbXF0Hiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 03:38:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44790 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751999AbXF0Hiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 03:38:51 -0400
Date: Wed, 27 Jun 2007 00:38:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
Message-Id: <20070627003841.68fd0ea9.akpm@linux-foundation.org>
In-Reply-To: <20070627073526.GA18787@havoc.gtf.org>
References: <20070627073526.GA18787@havoc.gtf.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007 03:35:26 -0400 Jeff Garzik <jeff@garzik.org> wrote:

> +	/* Don't allow DMA if it isn't multiple of 16 bytes.  Quite a
> +	 * few ATAPI devices choke on such DMA requests.
> +	 */
> +	if (unlikely(qc->nbytes & 15))
> +		return 1;

It might be worth emitting a diagnostic when this happens.
