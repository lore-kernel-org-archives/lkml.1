Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbZFVU5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbZFVU5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbZFVU5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 16:57:24 -0400
Received: from comar.pardus.org.tr ([193.140.100.220]:60039 "EHLO
	pardus.org.tr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751372AbZFVU5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 16:57:23 -0400
Message-ID: <4A3FF03A.4050401@pardus.org.tr>
Date: Mon, 22 Jun 2009 23:57:30 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Dave Airlie <airlied@linux.ie>
CC: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm v2.6.31 merge (part 1)
References: <alpine.DEB.2.00.0906120720410.11737@skynet.skynet.ie>
In-Reply-To: <alpine.DEB.2.00.0906120720410.11737@skynet.skynet.ie>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
> Hi Linus,
>
> Please pull the 'drm-linus' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus
>
> commit df4f7fe7bd516b3833e25c692c3970e22038a6ca
> Author: Dave Airlie <airlied@redhat.com>
> Date:   Thu Jun 11 16:16:10 2009 +1000
>
>     radeon: remove _DRM_DRIVER from the preadded sarea map
>     
>     This shouldn't be there and is what broke r600 late in the 2.6.30
>     release cycle with Ben's patch.
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
>   

Hi,

I wonder what kind of *breaking* should be expected without this commit
on r600'? I'm having serious lockups on X (RS690) and I don't have this
commit applied, I'll give it a try tomorrow but I'm really curious if it
may be related to this fix or not.

Thanks,
