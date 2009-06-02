Return-Path: <linux-kernel-owner+w=401wt.eu-S1758896AbZFBFIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896AbZFBFIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 01:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbZFBFHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 01:07:52 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:56032 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbZFBFHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 01:07:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=ce+VjAGdfZJhnYa6+hPDecjN6ruIGTaDreiWSsSIqoUjscGdisLe+ti3vArmci+CVj
         eeD0VPTCIk+GJDQ1+dQ7DuPazBOE4BN2pJ16qIvMUXha3EMJSXTz7CagpK2LwmPDaG0F
         00D7TKlvad6Ir7sClqt5cap/7O+J82A+v1f3o=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <f5a7b3810905220417m5bbef733s54524e1180a9d4f7@mail.gmail.com>
References: <f5a7b3810905220417m5bbef733s54524e1180a9d4f7@mail.gmail.com>
Date: Tue, 2 Jun 2009 07:07:52 +0200
Message-ID: <cfd18e0f0906012207i61621045je6d98db91d986c5f@mail.gmail.com>
Subject: Re: adjtimex system man page EINVAL
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: naresh kamboju <naresh.kernel@gmail.com>
Cc: ziegler@uni-freiburg.de, akpm@linux-foundation.org, johnstul@us.ibm.com,
       zippel@linux-m68k.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naresh,

On Fri, May 22, 2009 at 1:17 PM, naresh kamboju <naresh.kernel@gmail.com> wrote:
> Hi,
>
> Regarding adjtimex system man page,
>
> Since there are modifications noticed in
> /kerel/time/ntp.c
> /include/linux/timex.h
>
> compared with /kerel/time/ntp.c 2.6.23 and 2.6.29 and above i have
> attached adjtimex_2.6.23_vs_2.6.29.log : line number 330.
>
> In adjtimex (2) man page under the EINVAL Error check section changes
> are required w.r.t buf.offset.
> Could you conform and update the man page.

Could you please summarize in a couple of sentence what the actual
changes are that you think are required.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
