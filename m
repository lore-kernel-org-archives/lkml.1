Return-Path: <linux-kernel-owner+w=401wt.eu-S1765010AbYDPOeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765010AbYDPOeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 10:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbYDPOeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 10:34:16 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49340 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755106AbYDPOeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 10:34:15 -0400
Date: Wed, 16 Apr 2008 09:34:14 -0500
From: Dean Nelson <dcn@sgi.com>
To: Duck <duck@freescale.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generic pool allocator: allow all chunks to be allocated.
Message-ID: <20080416143414.GA4778@sgi.com>
References: <1208349190-9650-1-git-send-email-duck@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208349190-9650-1-git-send-email-duck@freescale.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 06:33:10AM -0600, Duck wrote:
> From: Bruce Schmid <duck@freescale.com>
> 
> gen_pool_alloc() doesn't allocate the last chunk in a pool.
> This patch fixes that problem by correcting the calculation
> of the number of the last bit in the bitmap.

Indeed it doesn't allocate the last bit. I ran a quick test
with and without your patch and your patch does fix the problem.

Acked-by: Dean Nelson <dcn@sgi.com>

