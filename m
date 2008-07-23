Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbYGWQya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbYGWQya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 12:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYGWQyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 12:54:22 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:37030 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbYGWQyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 12:54:21 -0400
Date: Wed, 23 Jul 2008 19:54:05 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Rik van Riel <riel@redhat.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: systemtap & backward compatibility, was Re: [RFC] systemtap:
	begin the process of using proper kernel APIs
Message-ID: <20080723165405.GE14846@cs181140183.pp.htv.fi>
References: <1216313914.5515.25.camel__21144.9282979176$1216314027$gmane$org@localhost.localdomain> <y0m7ibkjrcj.fsf@ton.toronto.redhat.com> <1216325546.5515.63.camel@localhost.localdomain> <20080717202634.GI18295@redhat.com> <1216328769.5515.78.camel@localhost.localdomain> <20080717213355.GJ18295@redhat.com> <20080722140015.37628ea4@bree.surriel.com> <20080723150434.GC11191@redhat.com> <20080723082856.334f9c17__2909.60763018138$1216827051$gmane$org@infradead.org> <y0m3am0blj2.fsf@ton.toronto.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <y0m3am0blj2.fsf@ton.toronto.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 12:41:37PM -0400, Frank Ch. Eigler wrote:
>...
> In the interim (before we come up with a way of moving more
> kernel-coupled systemtap code into kernel.org/git), would y'all
> consider an arrangement?  Those of you who care about systemtap, and
> are intending to make an incompatible kernel/module interface change,
> please run the systemtap testsuite before & after.  If it regresses,
> send us a note or a patch.  If practical, we'll integrate it (and add
> any backward-compatibility hacks if needed) into systemtap.

The number of incompatible kernel/module interface changes per kernel is 
most likely some medium three digit number.

What you have in mind is therefore not really feasible.

But we have several levels of kernels that incorporate future stuff, 
from -rc over -next to -mm, and you could implement automated runs 
of the systemtap testsuite against the latest ones.

> - FChE

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

