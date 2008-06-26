Return-Path: <linux-kernel-owner+w=401wt.eu-S1757694AbYFZR4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694AbYFZR4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 13:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYFZR4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 13:56:24 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:35532 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbYFZR4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 13:56:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fTsDHvpiDckX8JBF6CTW2Xs/wkfu4BWB5hKD4oEb1fkZ5ktCzWomrAwGN3T1nqEsSc
         NJQkheADnolG8jOoybvdGRwvlCq6S4kVz+uQumA81+30GIfVKhGYZww9wzjbF+GKBYQh
         oIHDWUu/nbu9OoUIzlzTKdRYIl/kr8v4h/hvw=
Message-ID: <19f34abd0806260953h504ff85dmf11a59171df3442b@mail.gmail.com>
Date: Thu, 26 Jun 2008 18:53:12 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: more header fixes
Cc: linux-kernel@vger.kernel.org, "the arch/x86 maintainers" <x86@kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20080626120202.GH29619@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080610214544.GA14824@damson.getinternet.no>
	 <20080618103006.GF15255@elte.hu>
	 <19f34abd0806180919v5a8c21e7ua7e1f928d8a53ab4@mail.gmail.com>
	 <20080626120202.GH29619@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 26, 2008 at 2:02 PM, Ingo Molnar <mingo@elte.hu> wrote:
> thanks Vegard, these changes are looking rather good. I've created a
> tip/x86/header-guards topic for it and did a test-merge. There were 30+
> trivial conflicts with tip/master that were easy to fix - find the list
> of conflicting files below.
>
> Lets keep these changes out of tip/master for now though, to reduce the
> churn - i'll do a merge/rebase in the v2.6.27-rc1 timeframe, ok?
>
> or perhaps we could include it in tip/master right now as well, if you
> did another branch that excluded the files below. That would make
> merging a lot easier - and we could do a second phase in v2.6.27-rc1.
> Hm?

I don't think we really need to resolve conflicts at all. What we can
do is simply to re-run the scripts against tip/master whenever you
want the update.

I have created a 'for-tip' branch at
git://git.kernel.org/pub/scm/linux/kernel/git/vegard/linux-2.6-headers.git
which is a re-run against the most recent tip/master. (The previous
link was against something rather old like -rc6.)

I am not sure this is what you wanted. In either case, re-running is
not a problem, and neither is excluding a set of files. Please do this
with as little pain for yourself as possible. The purpose of the
script is to avoid manual work.

Also, by the way: Can -tip now be cloned with --shared to save space
as long as I only have branches with references to commits in
tip/master? Or is this still to be considered unsafe?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
