Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbZDFVpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbZDFVpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbZDFVph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:45:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:26715 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbZDFVpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:45:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=afvJFhkJAxw/jxzi6oa12bfXpopfUGFppQQ1Zs7DMgajEQxXTY9ztiOGMjEMKE2QaO
         tQi1zC/H+Zais36KBg8T9vDJZqgckM2yJphD1dB92gmGohQCKXnfaV4Gdda6uqMaOUd5
         xBsmufzXG8vUgRv4gIfzbGy6UjVXW0YLjdxKs=
Date: Mon, 6 Apr 2009 23:45:29 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrey Borzenkov <arvidjaar@gmail.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: commit 66c1ca breaks fbdev mode switching
Message-ID: <20090406214528.GA17259@linux>
References: <498817E2.3020008@gmail.com> <1233783983-28802-1-git-send-email-righi.andrea@gmail.com> <200903221748.42871.arvidjaar@gmail.com> <200903221857.20473.rjw@sisk.pl> <20090322145219.ad294615.akpm@linux-foundation.org> <20090406204718.ce4909b3.krzysztof.h1@poczta.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090406204718.ce4909b3.krzysztof.h1@poczta.fm>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06, 2009 at 08:47:18PM +0200, Krzysztof Helt wrote:
> Hi,
> 
> The commit 66c1ca breaks fbdev mode switching. The first mode
> (selected with mode_option or during boot) is ok but every mode
> switch with fbset locks up computer. If the commit is reverted
> mode switching works correctly.
> 
> I do not understand why. I would be grateful if someone else
> can confirm the problem as well.
> 
> The commit's details are:
> 
> commit 66c1ca019078220dc1bf968f2bb18421100ef147
> Author: Andrea Righi <righi.andrea@gmail.com>
> Date:   Tue Mar 31 15:25:18 2009 -0700
> 
>     fbmem: fix fb_info->lock and mm->mmap_sem circular locking dependency
>     
> 
> Regards,
> Krzysztof

Any lockdep info or oops? it just locks up the system?

Thanks,
-Andrea
