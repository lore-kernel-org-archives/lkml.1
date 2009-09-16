Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbZIPLsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbZIPLsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 07:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbZIPLsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 07:48:32 -0400
Received: from mail-px0-f176.google.com ([209.85.216.176]:62594 "EHLO
	mail-px0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002AbZIPLsb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 07:48:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=I2vLOinju/SJzky6ylT3QkuGb6az1w6e+e7rSL4p1AQ5MMRMV0ALdZm7/HqxmJOorg
         cVLqULp4gzEoC9nrHC3bGg3rZSxECvQwqLTRYuA+jWBvy+A4/Wvp+qhUH/sSe98yDDed
         xXbe3wUiMcGTKmeiZSNoPovlfYM+yv9ywItPg=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0909161211100.12659@sister.anvils>
References: <20090915021851.168285585@intel.com>
	 <20090915120939.bcc571e1.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090915082200.GA2588@localhost>
	 <Pine.LNX.4.64.0909151057020.26095@sister.anvils>
	 <10f740e80909160201l4834369s75e63fe8df0991aa@mail.gmail.com>
	 <Pine.LNX.4.64.0909161211100.12659@sister.anvils>
Date: Wed, 16 Sep 2009 13:42:20 +0200
X-Google-Sender-Auth: aae3cff8d31a6ef3
Message-ID: <10f740e80909160442w470f70cao28a3b6de3e5689b4@mail.gmail.com>
Subject: Re: [PATCH 0/3] /proc/kmem cleanups and hwpoison bits
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       Nick Piggin <npiggin@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-m68k@vger.kernel.org, sparclinux@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 13:26, Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> On Wed, 16 Sep 2009, Geert Uytterhoeven wrote:
>> On Tue, Sep 15, 2009 at 12:16, Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
>> > Warning: it may be rubbish, it may just be a hack which appeared to
>> > work for me the last time I tried, on a particular address range of a
>> > particular set of configurations of a particular set of architectures
>> > (x86_32, x86_64, powerpc64).  I've never thought it through enough to
>> > consider submitting, but it _might_ contain something useful for you
>> > to factor into your own efforts.
>> >
>> > Sorry for chucking it over the wall to you in this way, but I guess
>> > that's better than just sitting quietly on it for a few more years.
>> >
>> > Certainly-Not-Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
>
> I think that gives a good idea of the status of this patch:
> I'm not making any policy decisions here or submitting to any tree.

OK, that was my understanding, too.

But I thought it would hurt to verify. You never know who's gonna take
your patch and (try to) sneak it in ;-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
