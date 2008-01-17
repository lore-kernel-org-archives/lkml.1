Return-Path: <linux-kernel-owner+w=401wt.eu-S1759463AbYAQXKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463AbYAQXKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 18:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761391AbYAQXKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 18:10:30 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48163 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761155AbYAQXK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 18:10:29 -0500
Date: Thu, 17 Jan 2008 15:10:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Schwartz <davids@webmaster.com>
cc: Johannes Weiner <hannes@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       clameter@sgi.com, penberg@cs.helsinki.fi
Subject: RE: Why is the kfree() argument const?
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKKEHDJJAC.davids@webmaster.com>
Message-ID: <alpine.LFD.1.00.0801171507570.2957@woody.linux-foundation.org>
References: <MDEHLPKNGKAHNMBLJOLKKEHDJJAC.davids@webmaster.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Jan 2008, David Schwartz wrote:
> 
> No, that's not what it means. It has nothing to do with memory. It has to do
> with logical state.

Blah. That's just your own made-up explanation of what you think "const"
should mean. It has no logical background or any basis in the C language.

"const" has nothing to do with "logical state".  It has one meaning, and 
one meaning only: the compiler should complain if that particular type is 
used to do a write access.

It says nothing at all about the "logical state of the object". It cannot, 
since a single object can - and does - have multiple pointers to it.

So your standpoint not only has no relevant background to it, it's also 
not even logically consistent.

		Linus
