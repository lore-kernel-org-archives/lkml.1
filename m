Return-Path: <linux-kernel-owner+w=401wt.eu-S1761967AbXHYMyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761967AbXHYMyR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 08:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbXHYMyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 08:54:06 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:2350 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbXHYMyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 08:54:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kDXQ/NyAYrXO+ftFiL6CnQgWUH73TkUGAAnFhcoC4cw4UX6tkPNhvsg70GGW/7TELcksax4zE74I7eB5Q7uHuREAM/UlrbHa8LpJdJjceLwDJF5RGA9vfyK8en7pcOq+tyvA87H2Sj+fIP6rP1bpDbTNxTtfCr7J1gb2d62jl5I=
Message-ID: <b637ec0b0708250554m35decdb3ic8db88787fc3c0c9@mail.gmail.com>
Date: Sat, 25 Aug 2007 14:54:01 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Problem with CFS V20 and Suspend2/tuxonice
Cc: "David Rodriguez" <livuxman@gmail.com>, Suspend2-users@lists.suspend2.net,
       suspend2-devel <suspend2-devel@lists.suspend2.net>
In-Reply-To: <1946b54f0708250429y570a1620y2796d0ff8abb02eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1946b54f0708250423k75d5797fuc5b032be7e143f26@mail.gmail.com>
	 <1946b54f0708250429y570a1620y2796d0ff8abb02eb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Reproduced on a Intel Centrino based laptop with gentoo kamikaze7
sources (http://forums.gentoo.org/viewtopic-t-577970.html)



On 8/25/07, David Rodriguez <livuxman@gmail.com> wrote:
> I'm using 2.6.22.5 with cfs v20.3 and  suspend2  2.2.10.2.
> With that combination, suspend is not working anymore (with cfs v19
> was working).
> Stops on suspend in "Suspending tasks"
> Looking at cfs patch, I managed to change the  migration_thread,
> adding again the  try_to_freeze() removed in last patch and now the
> suspend finished, but resume not work. Of course I don't know why that
> was removed, and rewriting it is not a solution, but I want to report
> it.
>
> All that in a core duo machine.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
