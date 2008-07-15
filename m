Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbYGOK47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbYGOK47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 06:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbYGOK4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 06:56:51 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:14133 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbYGOK4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 06:56:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Xobh8Qrxu1ugqC13aa1mYAG932ZUqzkxCY4AxK1XcsoVdQYwQp3B0WuTslq3tmqrBc
         QoH3FwNfeXyoSSN9pP48TPPjr4i9KJ+IjcwQfdzpZ8JMd1qrp5gqFcKGA3LDoZZpXULx
         XGvf8l0oNQ7LmZI4NB4EnnVZRsCuETbsodjaw=
Message-ID: <6101e8c40807150356t5ecb0885ud0249eff1ec03e77@mail.gmail.com>
Date: Tue, 15 Jul 2008 12:56:48 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Dave Airlie" <airlied@skynet.ie>
Subject: Re: [git pull] drm radeon fix for 2.6.27-rc1
Cc: torvalds@linux-foundation.org, "Andrew Morton" <akpm@linux-foundation.org>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       stable@kernel.org
In-Reply-To: <alpine.DEB.0.82.0807150702330.6038@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.0.82.0807150702330.6038@skynet.skynet.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

it affects stable (2.6.26) too?

On 7/15/08, Dave Airlie <airlied@skynet.ie> wrote:
>
> Hi Linus,
>
> Please pull the 'drm-fixes' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
> drm-fixes
>
> It appears we have a PAT incomPATibility, with how the radeon driver was
> mapping some VRAM.
>
> Dave.
>
>  drivers/gpu/drm/drm_memory.c       |    5 +++++
>  drivers/gpu/drm/radeon/radeon_cp.c |    2 +-
>  include/drm/drmP.h                 |    1 +
>  3 files changed, 7 insertions(+), 1 deletions(-)
>
> commit 242e3df80b8d25ed681c278512df0993725f25dd
> Author: Dave Airlie <airlied@linux.ie>
> Date:   Tue Jul 15 15:48:05 2008 +1000
>
>     drm/radeon: fixup issue with radeon and PAT support.
>
>     With new userspace libpciaccess we can get a conflicting mapping
>     on the PCIE GART table in the video RAM. Always try and map it _wc.
>
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
