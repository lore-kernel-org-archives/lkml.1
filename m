Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbYIEVzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbYIEVzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 17:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbYIEVzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 17:55:35 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:38837 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbYIEVze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 17:55:34 -0400
Date: Fri, 5 Sep 2008 14:54:52 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Gary Hade <garyhade@us.ibm.com>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Badari Pulavarty <pbadari@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       Chris McDermott <lcm@us.ibm.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [RESEND] x86_64: add memory hotremove config option
Message-ID: <20080905215452.GF11692@us.ibm.com>
References: <20080905172132.GA11692@us.ibm.com> <87ej3yv588.fsf@basil.nowhere.org> <20080905195314.GE11692@us.ibm.com> <20080905200401.GA18288@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905200401.GA18288@one.firstfloor.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2008 at 10:04:01PM +0200, Andi Kleen wrote:
> > The inability to offline all non-primary node memory sections
> > certainly needs to be addressed.  The pgdat removal work that
> > Yasunori Goto has started will hopefully continue and help resolve
> > this issue. 
> 
> You make it sound like it's just some minor technical hurdle
> that needs to be addressed.

Sorry, that was not my intent.

> But from all analysis of these issues
> I've seen so far it's extremly hard and all possible solutions
> have serious issues. So before doing some baby steps there
> should be at least some general idea how this thing is supposed
> to work in the end.

I am not sure if I understand why you appear to be opposed to
enabling the hotremove function before all the issues related
to an eventual goal of being able to free all memory on a node
are addressed.  Even in the absence of solutions for these issues
it seems like there could still be other possible benefits such
as the ability to selectively expand and shrink available memory
for testing or debugging purposes.  I believe it would also be
helpful to those working on or testing possible solutions for
the removal issues.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

