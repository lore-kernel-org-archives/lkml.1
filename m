Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbXENVVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbXENVVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 17:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbXENVVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 17:21:41 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751559AbXENVVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 17:21:40 -0400
Date: Mon, 14 May 2007 14:21:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: linux-pcmcia@lists.infradead.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [POWERPC] 8xx: mpc885ads pcmcia support
Message-Id: <20070514142125.851f3d10.akpm@linux-foundation.org>
In-Reply-To: <20070508223123.3633.72309.stgit@localhost.localdomain>
References: <20070508222748.3633.37120.stgit@localhost.localdomain>
	<20070508223123.3633.72309.stgit@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 May 2007 02:31:25 +0400
Vitaly Bordug <vitb@kernel.crashing.org> wrote:

> +/* 
> + * Some internal interrupt registers use an 8-bit mask for the interrupt
> + * level instead of a number.
> + */
> +static inline uint mk_int_int_mask(uint mask) {
> +	return (1 << (7 - (mask/2)));
> +}

grumble.  "uint" isn't a favoured "type".  Please prefer to
use "unsigned int" if that's what is meant.  Or maybe u32,
if that's more appropriate - and it probably is, as we're
dealing with device registers here.
