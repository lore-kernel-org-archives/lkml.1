Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbYI3W1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbYI3W1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 18:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbYI3W1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 18:27:46 -0400
Received: from ozlabs.org ([203.10.76.45]:36548 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbYI3W1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 18:27:46 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [patch 0/4] Cpu alloc V6: Replace percpu allocator in modules.c
Date: Wed, 1 Oct 2008 08:27:40 +1000
User-Agent: KMail/1.9.9
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jeremy@goop.org, ebiederm@xmission.com,
       travis@sgi.com, herbert@gondor.apana.org.au, xemul@openvz.org,
       penberg@cs.helsinki.fi
References: <20080929193500.470295078@quilx.com>
In-Reply-To: <20080929193500.470295078@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810010827.42124.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2008 05:35:00 Christoph Lameter wrote:
> Just do the bare mininum to establish a per cpu allocator. Later patchsets
> will gradually build out the functionality.

Hi Christoph,

   I'm not particularly attached to the allocator in module.c, and yours is 
more general.  And it's probably more efficient since most allocs are small.

> The most critical issue that came up awhile back was how to configure
> the size of the percpu area. Here we simply use a kernel parameter and use
> the static size of the existing percpu allocator for modules as a default.

Yerch.  OK, it *is* better than nothing.

Thanks for digging into this again,
Rusty.
