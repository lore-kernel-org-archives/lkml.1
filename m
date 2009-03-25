Return-Path: <linux-kernel-owner+w=401wt.eu-S1763820AbZCYSAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763820AbZCYSAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762876AbZCYSAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:00:04 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:44824 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762803AbZCYSAA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:00:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Q/3v7/1KOdhc7DGARZB6e+ih27m3yWxVqZBJCMpk4S0tdhxkRSmdybe/yzQ52NNooW
         ig5kMPLjly1QMa7piBq3iFbRmJDuTjyKyLj+IjmaaHZLrN7fQxVRyGSMFKU4SLZmUxVq
         KMMfcNoza2oFp/YU9yXkg16tEsa/Ra2rFc+is=
MIME-Version: 1.0
In-Reply-To: <20090324170559.1667c847@infradead.org>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	 <49C87B87.4020108@krogh.cc>
	 <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
	 <20090324091545.758d00f5@lxorguk.ukuu.org.uk>
	 <20090324093245.GA22483@elte.hu>
	 <20090324101011.6555a0b9@lxorguk.ukuu.org.uk>
	 <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu>
	 <20090324160353.06a4a5ed@hobbes.virtuouswap>
	 <20090324170559.1667c847@infradead.org>
Date: Wed, 25 Mar 2009 10:59:57 -0700
Message-ID: <72dbd3150903251059xc1fbc04qb1335e33bb0a2732@mail.gmail.com>
Subject: Re: Linux 2.6.29
From: David Rees <drees76@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Theodore Tso <tytso@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 5:05 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Tue, 24 Mar 2009 16:03:53 -0700
> Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>> I remember early in the 2.6.x days there was a lot of focus on making
>> interactive performance good, and for a long time it was.  But this
>> I/O problem has been around for a *long* time now... What happened?
>> Do not many people run into this daily?  Do all the filesystem
>> hackers run with special mount options to mitigate the problem?
>
> the people that care use my kernel patch on ext3 ;-)
> (or the userland equivalent tweak in /etc/rc.local)

There's a couple of comments in bug 12309 [1] which confirm that
increasing the priority of kjournald reduces latency significantly
since I posted your tweak there yesterday.  I hope to do some testing
today on my systems to see if it helps on them, too.

-Dave

[1] http://bugzilla.kernel.org/show_bug.cgi?id=12309
