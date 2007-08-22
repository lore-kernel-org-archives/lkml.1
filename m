Return-Path: <linux-kernel-owner+w=401wt.eu-S1763601AbXHVTCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763601AbXHVTCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 15:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755852AbXHVTCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 15:02:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:38710 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567AbXHVTCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 15:02:32 -0400
Date: Wed, 22 Aug 2007 21:55:50 +0200
From: Andi Kleen <ak@suse.de>
To: travis@sgi.com
Cc: Andi Kleen <ak@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 6/6] x86: acpi-use-cpu_physical_id
Message-ID: <20070822195550.GE8058@bingen.suse.de>
References: <20070822172101.138513000@sgi.com> <20070822172124.217932000@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822172124.217932000@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 10:21:07AM -0700, travis@sgi.com wrote:
> This is from an earlier message from Christoph Lameter:
> 
>     processor_core.c currently tries to determine the apicid by special casing
>     for IA64 and x86. The desired information is readily available via
> 
> 	    cpu_physical_id()
> 
>     on IA64, i386 and x86_64.

Have you tried this with a !CONFIG_SMP build? The drivers/dma code was doing
the same and running into problems because it wasn't defined there.

-Andi
