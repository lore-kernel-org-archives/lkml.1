Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367AbXDBHSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbXDBHSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 03:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbXDBHSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 03:18:33 -0400
Received: from ns1.suse.de ([195.135.220.2]:35000 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367AbXDBHSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 03:18:32 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 16/17] add kmap_atomic_pte for mapping highpte pages
Date: Mon, 2 Apr 2007 09:18:19 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Zachary Amsden <zach@vmware.com>
References: <20070402055652.610711908@goop.org> <20070402055705.499213579@goop.org>
In-Reply-To: <20070402055705.499213579@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704020918.20008.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> +}
> +
> +/* Flush all unused kmap mappings in order to remove stray
> +   mappings. */
> +void kmap_flush_unused(void)
> +{
> +	spin_lock(&kmap_lock);
> +	flush_all_zero_pkmaps();
> +	spin_unlock(&kmap_lock);
>  }

Who calls this now?

-Andi

