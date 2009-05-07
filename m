Return-Path: <linux-kernel-owner+w=401wt.eu-S1758930AbZEGCkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930AbZEGCkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 22:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbZEGCkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 22:40:25 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:40346 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbZEGCkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 22:40:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=URN+PtBdG9KvUVOYnpVOunUtVKnKFKQ304M+RXxiNdyigfL1M7FNsmsGHBxjG2h88a
         dxfJao57J2c6gOM6d4PbVwBUbEf/TNNaUtNiQ9KIRb1BOHz4WI9FTYdTmpPo/VJtPqZH
         nu89Vb9+1BBorU2kAqSiYmpSp8JGgAXOObALI=
Date: Thu, 7 May 2009 11:40:16 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, <linux-mm@kvack.org>
Subject: Re: [PATCH 4/7] proc: export more page flags in /proc/kpageflags
Message-Id: <20090507114016.40ee6577.minchan.kim@barrios-desktop>
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

On Thu, 07 May 2009 09:21:21 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> +	 * pseudo flags for the well known (anonymous) memory mapped pages
> +	 */
> +	if (!PageSlab(page) && page_mapped(page))
> +		u |= 1 << KPF_MMAP;
> +	if (PageAnon(page))
> +		u |= 1 << KPF_ANON;

Why do you check PageSlab on user pages ?
Is there any case that PageSlab == true && page_mapped == true ?

-- 
Kinds Regards
Minchan Kim
