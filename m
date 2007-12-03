Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbXLCE2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbXLCE2S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 23:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbXLCE2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 23:28:06 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:20597 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751204AbXLCE2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 23:28:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=h+d0xz9thQWiADpx9jZ5t4Dy0hZa5DRAS+hlVoK62W/4xlDBjuiVKXloAniTMYSZOFsLv53/JzssBJGOpJXfGER/+IF/F0tNvY2qkoEpYUOuUgDHGBSrtcDesWrnxCZLiZK+BfReyySE4vJeUaTFnYcr8LsuXRVA7cu/12mOMQ8=  ;
X-YMail-OSG: mHVzPZkVM1kCgGjn43BEpBoI448rYhvGH2E.wUIf2wWWOeJv
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
Date: Mon, 3 Dec 2007 15:27:56 +1100
User-Agent: KMail/1.9.5
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1196155985.25646.31.camel@ymzhang> <200711301429.15664.nickpiggin@yahoo.com.au> <20071130100845.GB2201@elte.hu>
In-Reply-To: <20071130100845.GB2201@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712031527.57129.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 November 2007 21:08, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > Haven't we been asking JVMs to use futexes or posix locking for years
> > and years now? [...]
>
> i'm curious, with what JVM was it tested and where's the source so i can
> fix their locking for them? Can the problem be reproduced with:

Sure, but why shouldn't the compat behaviour be the default, and the
sysctl go away?

It makes older JVMs work better, it is slightly closer to the old
behaviour, and it is arguably a less surprising result.

