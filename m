Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbXFTWk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbXFTWk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 18:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbXFTWkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 18:40:49 -0400
Received: from smtp009.mail.ukl.yahoo.com ([217.12.11.63]:23437 "HELO
	smtp009.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751352AbXFTWks convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 18:40:48 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jun 2007 18:40:47 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=diYlXPH2KSj5gkHYKramB+pIU+WOSJeIYm1cTpI5rh4aHsOfwn4j0DRAjcAhul1cWvuRLcK2A1/ATez/DBiuHpkV+G/Rf7YlbRsfo1Jm5I5VAK0vF84+w3CJwvgpGNN3da4iGgHTLOQMgvnYYg4dM2tEnkii8QsWH9fV289LVpU=  ;
X-YMail-OSG: ed5yAcoVM1nNgA1AKT66RgK5MlHLGQHhoYXuYK9qHN1Nw9qpi7x0_kvLWmVyqyFQf7fgSJh4BmrO3I6E0shJZE1QltFWSlT5LYx4khEFp2kt71lk
From: Blaisorblade <blaisorblade_spam@yahoo.it>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH 2/2] UML - Add stack usage monitoring
Date: Wed, 20 Jun 2007 22:20:15 +0200
User-Agent: KMail/1.9.7
Cc: Jeff Dike <jdike@addtoit.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20070619184245.GA10567@c2.user-mode-linux.org> <200706201606.58331.blaisorblade@yahoo.it> <20070620151753.GA6728@c2.user-mode-linux.org>
In-Reply-To: <20070620151753.GA6728@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706202220.15777.blaisorblade_spam@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On mercoledì 20 giugno 2007, Jeff Dike wrote:
> On Wed, Jun 20, 2007 at 04:06:58PM +0200, Blaisorblade wrote:
> > Oh, it's exactly what CONFIG_DEBUG_STACK_USAGE does for i386... (not sure
> > if you were still wondering...).
>
> Where?  The only usage in i386 that I see is thread_info.h zeroing stacks
> as they are allocated.

I only looked at docs. But Andrew Morton said:

"Your new code should really be generic, utilising the
stack-page-zeroing which CONFIG_DEBUG_STACK_USAGE enables."

In fact, the other reference is in kernel/sched.c. You may (or may not) join 
the two stack walking (I would) and match a bit descriptions.

Personally, I'd put the Kconfig option in lib/Kconfig.debug and have a Kconfig 
flag named DEBUG_STACK_USAGE_SUPPORT, much like LOCKDEP_SUPPORT (defined only 
by architectures supporting the option), but have no time right now.

Bye
-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
