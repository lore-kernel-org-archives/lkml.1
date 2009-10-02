Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbZJBQeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbZJBQeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 12:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756104AbZJBQeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 12:34:01 -0400
Received: from mail-gx0-f212.google.com ([209.85.217.212]:51598 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbZJBQeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 12:34:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=vYry/Avb/d4wNK6Os546adiXUy5OqWZl+TFjB66gpdsVEbmQC1F+zbdGgTTH59HI3k
         yQ4pjrht4nbCQ4SWYqPE+CJz4hYOMzpH2PbgojXH08pNkF6l6Hb9p5vO9zSXnnOmio5N
         vOZfOTfMDoEvIL8vz5AwHetNLKYIknEatXuyk=
MIME-Version: 1.0
In-Reply-To: <20091002145610.GD31616@kernel.dk>
References: <1254340730.7695.32.camel@marge.simson.net> <20090930202447.GA28236@redhat.com> 
	<1254382405.7595.9.camel@marge.simson.net> <20091001185816.GU14918@kernel.dk> 
	<1254464628.7158.101.camel@marge.simson.net> <20091002080417.GG14918@kernel.dk> 
	<20091002092409.GA19529@elte.hu> <20091002092839.GA26962@kernel.dk> 
	<alpine.LFD.2.01.0910020715160.6996@localhost.localdomain> 
	<20091002145610.GD31616@kernel.dk>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Fri, 2 Oct 2009 09:33:44 -0700
X-Google-Sender-Auth: 7498728d49305e08
Message-ID: <2c0942db0910020933l6d312c6ahae0e00619f598b39@mail.gmail.com>
Subject: Re: IO scheduler based IO controller V10
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Vivek Goyal <vgoyal@redhat.com>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       riel@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 2, 2009 at 7:56 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> In some cases I wish we had a server vs desktop switch, since it would
> decisions on this easier. I know you say that servers care about
> latency, but not at all to the extent that desktops do. Most desktop
> users would gladly give away the top of the performance for latency,
> that's not true of most server users. Depends on what the server does,
> of course.

If most of the I/O on a system exhibits seeky tendencies, couldn't the
schedulers notice that and use that as the hint for what to optimize?

I mean, there's no switch better than the actual I/O behavior itself.
