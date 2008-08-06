Return-Path: <linux-kernel-owner+w=401wt.eu-S1761654AbYHFPqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761654AbYHFPqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761216AbYHFPnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:43:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761208AbYHFPnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:43:40 -0400
Date: Wed, 6 Aug 2008 08:43:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH]: radeonfb: Fix copyarea for R300 and later.
Message-Id: <20080806084329.9d7e6d50.akpm@linux-foundation.org>
In-Reply-To: <20080806.003536.204220123.davem@davemloft.net>
References: <20080806.003536.204220123.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Aug 2008 00:35:36 -0700 (PDT) David Miller <davem@davemloft.net> wrote:

> [ Andrew/Ben, this fixes the bootup hang we were talking about
>   the other day. ]
> 
> radeonfb: Fix copyarea for R300 and later.
> 
> For current chips we need to make sure the DSTCACHE_CTLSTAT and
> WAIT_UNTIL registers are properly setup.  If not, a sequence of
> copyarea operations can result in the 2D raster processor
> hanging.

Neato.  This can be backported to -stable without also backporting your
recent radeon-misc-corrections.patch, I assume?

