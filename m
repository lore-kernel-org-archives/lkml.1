Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab0AOMoL (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 07:44:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757171Ab0AOMoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 07:44:10 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55541 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab0AOMoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 07:44:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CceCrc39Ci/2gupQ/Xm8KdDURMMBaQsnx66/xxACaygruPHeMpCy2dqWfKt4idWpfk
         cFJ6SBXvK7vnIdcxC44ZgxwXrHVThQ+qegu7DEM+YgitY50HyEE7/6HbWRMDcFySiuoJ
         6FqwjHbwclX4NvUFpvy6oclVnP36Px4RV+TyE=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1001151303580.23543@ask.diku.dk>
References: <4B502C6B.7000802@s5r6.in-berlin.de>
	 <20100115.005445.263291449.davem@davemloft.net>
	 <tkrat.e88dd4dbf17f9bde@s5r6.in-berlin.de>
	 <20100115.012233.202457727.davem@davemloft.net>
	 <Pine.LNX.4.64.1001151039080.23543@ask.diku.dk>
	 <84144f021001150149u3b784d26g1822be6c5c3ecbf@mail.gmail.com>
	 <Pine.LNX.4.64.1001151101320.23543@ask.diku.dk>
	 <20100115110845.GB28625@sirena.org.uk>
	 <Pine.LNX.4.64.1001151303580.23543@ask.diku.dk>
Date: Fri, 15 Jan 2010 14:44:06 +0200
X-Google-Sender-Auth: 0c5e83a7f64d01f9
Message-ID: <84144f021001150444j4f7f9dexe8486d06b7e45205@mail.gmail.com>
Subject: Re: Changelog quality
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Julia Lawall <julia@diku.dk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Miller <davem@davemloft.net>, stefanr@s5r6.in-berlin.de,
        adi@hexapodia.org, nm127@freemail.hu, david.vrabel@csr.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, cocci@diku.dk,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Palix <npalix@diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

On Fri, Jan 15, 2010 at 2:06 PM, Julia Lawall <julia@diku.dk> wrote:
> On the other hand, one has to take into account the fact that at least in
> my case, the patches that are submitted are the ones that I have carefully
> checked for correctness.  Having a make target in the kernel might give
> some suggestion of quality that is perhaps not appropriate?

I don't see the problem. No tool is perfect so the only thing that
matters is whether or not the benefits outweigh the costs. The problem
I see with Coccinelle is that the scripts seem to be lost in a black
hole (even if they are part of the changelog) which also means that
your efforts don't scale.

There seems to be a universal law regarding kernel development: if
something is out-of-tree, it simply doesn't matter from "people
scalability" point of view. It doesn't really matter if you like it or
not but that's the way things are right now. I, for one, would love to
run Coccinelle on the tree I maintain but unfortunately the tool fails
my "can I set it up in two minutes" rule so I haven't gotten around to
give it a try. And I suspect I am not the only one.

So why not try it out? If the signal to noise ratio is too low and we
can't fix that, we can always just remove the damn thing from the
tree. Speculating whether or not something will work seems pretty
pointless to me when you don't have any hard data.

                        Pekka
