Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbYFVVYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbYFVVYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 17:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756117AbYFVVYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 17:24:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:44536 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004AbYFVVYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 17:24:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VqnQsaYLMNnzEUBDhcrpdqWMlFfjPbkkaWjZ8cwXg9oc1OCftsAb67XR4TJpoRgCln
         X6GRs0rFH3BPbu8DufKN2mh+ZxGO8gO4WMffWRrYx/5lGf/eO2LI29UWdqQKAU6dcWIh
         wwD5jrp/h0tXHAu6v8jlOWikfmkbBTha6BSEU=
Message-ID: <19f34abd0806221424g1a96025dv86e36bb237d2dce1@mail.gmail.com>
Date: Sun, 22 Jun 2008 23:24:06 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH -tip-rcu] Make rcutorture more vicious: make quiescent rcutorture less power-hungry
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, josh@freedesktop.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, dino@in.ibm.com,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       adobriyan@gmail.com, oleg@tv-sign.ru, bunk@kernel.org, rjw@sisk.pl
In-Reply-To: <19f34abd0806221358k35d18279g4365b4aee32da194@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080618122144.GA27143@linux.vnet.ibm.com>
	 <20080618162649.GA18326@linux.vnet.ibm.com>
	 <20080622200638.GA25328@linux.vnet.ibm.com>
	 <19f34abd0806221358k35d18279g4365b4aee32da194@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 10:58 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Sun, Jun 22, 2008 at 10:06 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
>> This patch makes the non-module rcutorture a bit more friendly to
>> the power-conservation code.  This is a rather simple-minded approach.
>> More sophisticated approaches would get rid of the rcutorture tasks
>> while rcutorture execution was suppressed, but attempts thus far to
>> do this have not gone well -- calling rcu_torture_init() from a /proc
>> callout results in oopses.
>
> Hi Paul,
>
> I applied your three patches
>
> [PATCH] Make rcutorture more vicious: add stutter feature
> [PATCH] Make rcutorture more vicious: reinstate boot-time testing
> [PATCH -tip-rcu] Make rcutorture more vicious: make quiescent
> rcutorture less power-hungry
>
> to v2.6.26-rc7 and gave it a quick testing in qemu. But it seems to
> hang during gdb self-tests at boot:

Okay, you might disregard that. I'm typing on the very same kernel
running on a real machine now, so I assume that it's just qemu's
fault. (Actually, setting the number of cpus to 2 instead of 3 would
run the kgdb tests, but with a lot of warnings). But qemu is known to
have been buggy with these things before. (Sorry for the noise.)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
