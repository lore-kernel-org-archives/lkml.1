Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbZEHNuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbZEHNuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 09:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbZEHNuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 09:50:10 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42822 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbZEHNuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 09:50:09 -0400
Subject: Re: [RFC/PATCH v2] mm: Introduce GFP_PANIC for non-failing
 allocations
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, cl@linux.com, mingo@elte.hu,
       mel@csn.ul.ie, linux-kernel@vger.kernel.org, riel@redhat.com,
       rientjes@google.com, xemul@openvz.org
In-Reply-To: <20090508133704.GE6132@lenovo>
References: <20090504122740.GH4173@lenovo> <20090504131311.GA23330@elte.hu>
	 <20090504131638.GJ4173@lenovo>
	 <alpine.DEB.1.10.0905040940490.9553@qirst.com>
	 <20090504115335.9bc08587.akpm@linux-foundation.org>
	 <20090504192117.GB31176@lenovo>
	 <20090504123453.d130a6cf.akpm@linux-foundation.org>
	 <20090504200925.GD31176@lenovo> <1241787448.28600.26.camel@penberg-laptop>
	 <20090508133704.GE6132@lenovo>
Date: Fri, 08 May 2009 16:50:07 +0300
Message-Id: <1241790607.28600.36.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-08 at 17:37 +0400, Cyrill Gorcunov wrote:
> Thanks Pekka! At moment it's usefull for x86 uv_system_init (3 times)
> for early boot code. Plain panic_on_null (suggested by Andrew) could
> be usefull as well but would lead to additional wrapper around kmalloc
> which is already inlined. Which means -- at moment we have those cases
> handled by BUG_ON but having one common option would be better I guess
> (ie have an ability to say page allocator that just do panic on fail).
> 
> Anyway, if there is still objections on such an approach (even having
> gpf bits saved by elegant way Pekka suggested) -- I'm fine with having
> those BUG_ONs instead of short and gracious GFP_PANIC :)

There are such BUG_ONs in SLUB, for example, and probably elsewhere in
early-boot code.

			Pekka

