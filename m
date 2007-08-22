Return-Path: <linux-kernel-owner+w=401wt.eu-S1760234AbXHVTDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234AbXHVTDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 15:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755852AbXHVTC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 15:02:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60984 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762691AbXHVTCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 15:02:55 -0400
Date: Wed, 22 Aug 2007 21:56:45 +0200
From: Andi Kleen <ak@suse.de>
To: travis@sgi.com
Cc: Andi Kleen <ak@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 5/6] x86: fix cpu_to_node references
Message-ID: <20070822195645.GF8058@bingen.suse.de>
References: <20070822172101.138513000@sgi.com> <20070822172124.071200000@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822172124.071200000@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 10:21:06AM -0700, travis@sgi.com wrote:
> Fix four instances where cpu_to_node is referenced
> by array instead of via the cpu_to_node macro.  This
> is preparation to moving it to the per_cpu data area.

Shouldn't this patch be logically before the per cpu 
conversion (which is 3/6). This way the result would
be git bisectable.

-Andi

