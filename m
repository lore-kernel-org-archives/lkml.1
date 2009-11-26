Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbZKZOdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbZKZOdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 09:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbZKZOdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 09:33:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbZKZOdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 09:33:16 -0500
Date: Thu, 26 Nov 2009 15:27:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 0/14] utrace/ptrace
Message-ID: <20091126142745.GA4382@redhat.com>
References: <20091124200127.GA5751@redhat.com> <20091125214818.GA4916@infradead.org> <20091126091052.GF1389@elte.hu> <20091126104722.GA8316@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091126104722.GA8316@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26, Christoph Hellwig wrote:
>
> What the patches in the current form do is to introduce two different
> ptrace implementations, with one used on the architectures getting most
> testing and another secondary one for left over embedded or dead
> architectures with horrible results.

Yes, nobody likes 2 implementations. I guess Roland and me hate
CONFIG_UTRACE much more than anybody else.

> So removing the old one is much
> better.

I am in no position to discuss this option. It is very easy to remove
the old code and break !HAVE_ARCH_TRACEHOOK architectures. Although
personally I am not sure this is practical.

If we merge utrace, perhaps we will get more attention from maintainers,
the old code will be "officially" deprecated/obsolete. I sent some
trivial initial changes in arch/um/ a long ago, the patch was silently
ignored.

Even if I was able to fix arch/xxx myself, I don't understand how can
I send the patches to maintainers until utrace is already merged in
-mm at least.

Oleg.

