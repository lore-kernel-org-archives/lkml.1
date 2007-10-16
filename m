Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbXJPALW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbXJPALW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 20:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbXJPALP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 20:11:15 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:38802 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752973AbXJPALO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 20:11:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PF8YwUCVfICH/DPbLrNCVtR6Ea2RmLGlDFaywwEldq2i6+WWXPLyxU/s15Qj0kUYVR1A9Gkpfe0M31SMQ0kpVyxi9vfrbXQJktZBT0dn1emDJzkQAjUIKnKSLW7dYVFNWAc1nndxsNYqZST4iMugF0idpiHmxT3rjCK9OBeUyJ0=  ;
X-YMail-OSG: FX0WlMkVM1k_ltU7wbCCr1SydxezlNsBNf.XaeQSEezskAJzwh5Pd9ifNEAmz2Ef5actwvrPxIqrwlXZoEQ0CaZ67O3Exr01MNy5KoNw7_obLo4IROoRkv94cMiQcQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [git pull] scheduler updates for v2.6.24
Date: Tue, 16 Oct 2007 12:38:47 +1000
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20071015141723.GA29486@elte.hu>
In-Reply-To: <20071015141723.GA29486@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710161238.47432.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 October 2007 00:17, Ingo Molnar wrote:
> Linus, please pull the latest scheduler git tree from:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git
>
> It contains lots of scheduler updates from lots of people - hopefully
> the last big one for quite some time. Most of the focus was on
> performance (both micro-performance and scalability/balancing), but
> there's the fair-scheduling feature now Kconfig selectable too. Find the
> shortlog below.

Nice work...

However it's a pity all the balancing stuff got wildly changed
in 2.6.23 and then somewhat changed back again now.

Despite appearances, a lot of those things weren't actually
*completely* arbitrary values. I fear that it will make finding
performance regressions harder than it should have...

Anyway.

