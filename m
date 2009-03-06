Return-Path: <linux-kernel-owner+w=401wt.eu-S1757059AbZCFTik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbZCFTik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbZCFTib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:38:31 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:7626 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbZCFTib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:38:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nsMR4yuG7/da8muTMTmEHn/mvh4O2yYBCEgsgmp+R0Z75OJi0VhHNp5+ytjpHO7DMu
         RAZAU4UzLFnERRiIwCAhnwlLh1jnZZGB8ukiXqTRmSKKwG350S6tMHIJZThDnSOjw+CE
         OmDHfr5r/cnqKSwyw8PFN/NefFTKH0Vpjhtk4=
Date: Fri, 6 Mar 2009 22:38:23 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 03/18] dma-debug: add hash functions for
	dma_debug_entries
Message-ID: <20090306193823.GG7420@localhost>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com> <1236346229-6618-4-git-send-email-joerg.roedel@amd.com> <20090306135052.GE5988@nowhere> <20090306184514.GE7420@localhost> <20090306191059.GE7329@nowhere> <20090306191641.GF7420@localhost> <20090306192535.GD6966@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306192535.GD6966@amd.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Joerg Roedel - Fri, Mar 06, 2009 at 08:25:35PM +0100]
...
| > Nod :) The only problem could be (it depends) -- is that
| > if one day some locking would be needed instead of fixing
| > one function you would need to grep all list_add/del entries :)
| 
| The access is already locked. And as the functions are only called
| once each gcc should inline them automatically. At least gcc inlined
| them in my kernels :)
| 
| 	Joerg

I didn't checked the precise code logic neither details, just wanted
to point out that 'wrapping' functions are beneficial sometimes (especially
when they hide details of internal data and provide some kind of interface
to play with). Dunno Joerg, I think it would be better to point out that
we want those functions being inlined by gcc 'inline' attribute explicitly.
But you choose :)

	- Cyrill -
