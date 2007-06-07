Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbXFGGHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbXFGGHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 02:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbXFGGHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 02:07:35 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:52672 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbXFGGHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 02:07:34 -0400
Date: Thu, 7 Jun 2007 15:06:18 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Richard Purdie <rpurdie@openedhand.com>
Cc: akpm <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
       Nitin Gupta <nitingupta910@gmail.com>
Subject: Re: [PATCH -mm] Add LZO1X compression support to the kernel
Message-ID: <20070607060618.GA14759@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Richard Purdie <rpurdie@openedhand.com>,
	akpm <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Nitin Gupta <nitingupta910@gmail.com>
References: <1181150792.5686.51.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181150792.5686.51.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 06:26:32PM +0100, Richard Purdie wrote:
> +/* Which machines to allow unaligned accesses on */
> +#if defined(CONFIG_X86_32) || defined(CONFIG_X86_64)
> +#define LZO_UNALIGNED_OK_2
> +#define LZO_UNALIGNED_OK_4
> +#endif
> +
This is silly, just use get/put_unaligned(). This same issue was pointed
out in Nitin's patch and already corrected there, perhaps it would be
more constructive to work on getting cleanups from both implementations
integrated in to something mergeable rather than trying to see who can
get in to -mm first.
