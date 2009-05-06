Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbZEFHDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbZEFHDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 03:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbZEFHD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 03:03:29 -0400
Received: from mail-qy0-f125.google.com ([209.85.221.125]:57089 "EHLO
	mail-qy0-f125.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbZEFHD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 03:03:28 -0400
X-Greylist: delayed 1153 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 May 2009 03:03:27 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NeE0ggtSPvZn4e9XGfhtuIv66wBuxycMTR7SGUX3NCisVs7kKntoVRLsejYdQu5w4u
         qhuRtjcOHzLdoiG/6nLXA2APOONV6dZRuQja6kiZ2HujML6gDcnc0yePsBbcqzpG83IJ
         QhhDH4XsUhYouGAziYxPfJaVOQCKrKjOGKWfw=
Date: Wed, 6 May 2009 11:03:23 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, LMMML <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH -mmotm] mm: setup_per_zone_inactive_ratio - fix comment
	and make it __init
Message-ID: <20090506070323.GC4865@lenovo>
References: <20090506061923.GA4865@lenovo> <20090506155145.e657b271.minchan.kim@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506155145.e657b271.minchan.kim@barrios-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Minchan Kim - Wed, May 06, 2009 at 03:51:45PM +0900]
| On Wed, 6 May 2009 10:19:23 +0400
| Cyrill Gorcunov <gorcunov@openvz.org> wrote:
| 
| > The caller of setup_per_zone_inactive_ratio is module_init function.
| 
| __init :)
| 
| > No need to keep the callee after is completed as well.
| > Also fix a comment.
| > 
| > CC: David Rientjes <rientjes@google.com>
| > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
| 
| Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
| I guess the comment was a typo. 

Thanks Minchan. Actually it's not a typo :)
module_init function is supposed to be __initcall
function anyway. But it's confusing I could fix
changelog.

	-- Cyrill
