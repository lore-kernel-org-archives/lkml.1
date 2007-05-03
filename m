Return-Path: <linux-kernel-owner+w=401wt.eu-S1767356AbXECDsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767356AbXECDsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 23:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767359AbXECDsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 23:48:21 -0400
Received: from smtp-out.google.com ([216.239.33.17]:56108 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767356AbXECDsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 23:48:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=FpFy0Vwcsdjk7G9UJTsNhQmgIK1cCe9CxWBoHFvWmx4cH7RTil5XXojoMwh6ImStY
	YzmGNaSkFov4ro1qz4MqA==
Message-ID: <b040c32a0705022048p6c08fd41wcca7ac628d4229bc@mail.gmail.com>
Date: Wed, 2 May 2007 20:48:08 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: cache-pipe-buf-page-address-for-non-highmem-arch.patch
Cc: "Christoph Hellwig" <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "Andi Kleen" <ak@suse.de>
In-Reply-To: <20070501020441.10b6a003.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	 <20070501085431.GD14364@infradead.org>
	 <20070501020441.10b6a003.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> Fair enough, it is a bit of an ugly thing.  And I see no measurements there
> on what the overall speedup was for any workload.
>
> Ken, which memory model was in use?  sparsemem?

discontigmem with config_numa on.
