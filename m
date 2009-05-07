Return-Path: <linux-kernel-owner+w=401wt.eu-S1761474AbZEGCE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761474AbZEGCE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 22:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbZEGCEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 22:04:48 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:63702 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbZEGCEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 22:04:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=J3Ae9AMT44gbeIo/NpD8OdVZEKIEVLVgQX+yjzeQGMKdZMEGT83s4AMHlnQAiFjawR
         9Aww+79SpdzcgHGI0W+ETuFLK2LGhI8hsODu0ILKENGDv4RoNoOww9wRtwR2HH0uPPcT
         i4v3d7u3OBmCBDpel/U951h2G05UdSCBlS8rw=
Date: Thu, 7 May 2009 11:04:31 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, <linux-mm@kvack.org>
Subject: Re: [PATCH 4/7] proc: export more page flags in /proc/kpageflags
Message-Id: <20090507110431.b6a10746.minchan.kim@barrios-desktop>
In-Reply-To: <20090507014914.364045992@intel.com>
References: <20090507012116.996644836@intel.com>
	<20090507014914.364045992@intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

> +#ifdef CONFIG_MEMORY_FAILURE
> +	u |= kpf_copy_bit(k, KPF_HWPOISON,	PG_hwpoison);
> +#endif

Did mmtom merge memory failure feature?

-- 
Kinds Regards
Minchan Kim
