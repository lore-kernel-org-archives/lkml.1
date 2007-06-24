Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbXFXKC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbXFXKC0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 06:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbXFXKCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 06:02:18 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:52329 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbXFXKCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 06:02:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U2HJzZFfo3vD9V3zeWPXYzpt2RQ9upQ1nN+nN2bgy4EHyUdPSaMUS0POzJ68k4nvXVrqqiZPzPTKVnNMmLP3JQ02kGqfx3jYgkVdCUxgRKGV/e+fjxp/9rGVrYf0CjL3msnYK67039s1jNDJRZbAuBSb5RiaNYZVSfdzCltZmD0=
Message-ID: <5486cca80706240302mdebff81qaeaea9699ceb8564@mail.gmail.com>
Date: Sun, 24 Jun 2007 12:02:16 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v18
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070623172557.GA27435@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070622220202.GA16872@elte.hu>
	 <5486cca80706230322k6e3c0f81u8e3d149ca04dc041@mail.gmail.com>
	 <20070623172557.GA27435@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/6/23, Ingo Molnar <mingo@elte.hu>:
>
> * Antonino Ingargiola <tritemio@gmail.com> wrote:
>
> > 2007/6/23, Ingo Molnar <mingo@elte.hu>:
> > >
> > >i'm pleased to announce release -v18 of the CFS scheduler patchset.
> >
> > I'm running -v18 on 2.6.22-rc5, no problems so far. How can I change a
> > task to SCHED_IDLE or SCHED_BATCH priority under CFS?
>
> pick up schedtool, and these are the choices it gives:
>
>     -N                    for SCHED_NORMAL
>     -F -p PRIO            for SCHED_FIFO       only as root
>     -R -p PRIO            for SCHED_RR         only as root
>     -B                    for SCHED_BATCH
>     -I -p PRIO            for SCHED_ISO
>     -D                    for SCHED_IDLEPRIO
>
> then for example to start up something as SCHED_IDLE:
>
>   schedtool -D -e ./somecommand.sh
>

Thank you very much! I was thinking that schedtool was suitable only
for -ck. I've installed schedtool and it works fine.

Anyway, I've discovered with great pleasure that CFS has also the
SCHED_ISO priority. I may have missed something, but I don't remember
to have read this in any of the CFS release notes :). For me this is a
really useful feature. Thanks.


Regards,

    ~ Antonio

>         Ingo
>
