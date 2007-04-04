Return-Path: <linux-kernel-owner+w=401wt.eu-S1752413AbXDDWMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbXDDWMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 18:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbXDDWMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 18:12:33 -0400
Received: from waste.org ([66.93.16.53]:44851 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404AbXDDWMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 18:12:32 -0400
Date: Wed, 4 Apr 2007 16:59:32 -0500
From: Matt Mackall <mpm@selenic.com>
To: Nikita Danilov <nikita@clusterfs.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/13] maps: Add /proc/pid/pagemap interface
Message-ID: <20070404215932.GB4892@waste.org>
References: <1.486631555@selenic.com> <13.486631555@selenic.com> <17939.35217.938339.677599@gargle.gargle.HOWL> <20070404163232.GV4892@waste.org> <17939.59480.445304.429384@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17939.59480.445304.429384@gargle.gargle.HOWL>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 10:03:04PM +0400, Nikita Danilov wrote:
> Matt Mackall writes:
> 
> [...]
> 
>  > 
>  > Now I could adjust these to only export u64s in some preferred
>  > endianness. But given I already need details like the page size to
>  > make any sense of it, it seems unnecessary. Also, the PFNs are fairly
>  > opaque unless you're attempting to correlate them with /proc/kpagemap.
> 
> Alternatively, you can export some meta-data at the beginning of that
> file like /proc/profile does.

That seems reasonable. We need page size, entry size (4 or 8 bytes), and
an endian marker. I'll see what I can come up with.

-- 
Mathematics is the supreme nostalgia of our time.
