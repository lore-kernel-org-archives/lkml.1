Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbZIXBH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbZIXBH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 21:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbZIXBHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 21:07:24 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55726 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbZIXBHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 21:07:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 24 Sep 2009 10:05:18 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: No more bits in vm_area_struct's vm_flags.
Message-Id: <20090924100518.78df6b93.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4AB9A0D6.1090004@crca.org.au>
References: <4AB9A0D6.1090004@crca.org.au>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009 14:15:18 +1000
Nigel Cunningham <ncunningham@crca.org.au> wrote:

> Hi all.
> 
> With the addition of the VM_MERGEABLE flag to vm_flags post-2.6.31, the
> last bit in vm_flags has been used.
> 

Wow...that's bad.



> I have some code in TuxOnIce that needs a bit too (explicitly mark the
> VMA as needing to be atomically copied, for GEM objects), and am not
> sure what the canonical way to proceed is. Should a new unsigned long be
> added? The difficulty I see with that is that my flag was used in
> shmem_file_setup's flags parameter (drm_gem_object_alloc), so that
> function would need an extra parameter too..
> 

Hmm, how about adding vma->vm_flags2 ?

Thanks,
-Kame


> Regards,
> 
> Nigel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

