Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbZHNGIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbZHNGIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 02:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbZHNGId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 02:08:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:58120 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670AbZHNGIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 02:08:32 -0400
Message-ID: <4A84FF22.9040008@kernel.org>
Date: Fri, 14 Aug 2009 15:07:30 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, dhowells@redhat.com,
       npiggin@suse.de, JBeulich@novell.com, cl@linux-foundation.org,
       rusty@rustcorp.com.au, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org
Subject: Re: [PATCH 14/20] vmalloc: implement pcpu_get_vm_areas()
References: <1248171979-29166-1-git-send-email-tj@kernel.org> <1248171979-29166-15-git-send-email-tj@kernel.org>
In-Reply-To: <1248171979-29166-15-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 14 Aug 2009 06:07:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
...
> +	vmap_area_pcpu_hole = base + offsets[last_area];
> +
> +	spin_unlock(&vmap_area_lock);
> +
> +	/* insert all vm's */
> +	for (area = 0; area < nr_vms; area++)
> +		insert_vmalloc_vm(vms[area], vas[area], 0,
> +				  pcpu_get_vm_areas);

Changed the flags argument from 0 to VM_ALLOC.

Thanks.

-- 
tejun
