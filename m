Return-Path: <linux-kernel-owner+w=401wt.eu-S1755706AbZJVQUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbZJVQUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 12:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754983AbZJVQUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 12:20:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753714AbZJVQUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 12:20:10 -0400
Date: Thu, 22 Oct 2009 14:17:18 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, xma@us.ibm.com
Subject: Re: [PATCH] virtio-pci: fix per-vq MSI-X request logic
Message-ID: <20091022161718.GA3876@amt.cnet>
References: <20091022130606.GA6923@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091022130606.GA6923@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 03:06:06PM +0200, Michael S. Tsirkin wrote:
> Commit f68d24082e22ccee3077d11aeb6dc5354f0ca7f1
> in 2.6.32-rc1 broke requesting IRQs for per-VQ MSI-X vectors:
> - vector number was used instead of the vector itself
> - we try to request an IRQ for VQ which does not
>   have a callback handler
> 
> This is a regression that causes warnings in kernel log,
> potentially lower performance as we need to scan vq list,
> and might cause system failure if the interrupt
> requested is in fact needed by another system.
> 
> This was not noticed earlier because in most cases
> we were falling back on shared interrupt for all vqs.

Works for me. Thanks Michael.

Tested-by: Marcelo Tosatti <mtosatti@redhat.com>
