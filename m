Return-Path: <linux-kernel-owner+w=401wt.eu-S1758002AbXHBWgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbXHBWgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 18:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbXHBWgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 18:36:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:35922 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751002AbXHBWgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 18:36:39 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18msLoZmHImRDhnRaVrcA8mz5HZCgK5HljA7s/9mV
	YiXKMJ234e+LrZ
Date: Fri, 3 Aug 2007 00:36:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Hancock <hancockr@shaw.ca>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
In-Reply-To: <46B2578A.805@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.60.0708030024490.6774@poirot.grange>
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange>
 <p73vebxmysb.fsf@bingen.suse.de> <Pine.LNX.4.60.0708022231160.6774@poirot.grange>
 <46B2578A.805@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007, Robert Hancock wrote:

> Because 5 characters will not fit in a 4 character array, even without the
> null terminator.

On Fri, 3 Aug 2007, Stefan Richter wrote:

> How should gcc know whether you actually wanted that char foo[len] to
> contain a \0 as last element?

Robert, Stefan, I am sorry, I think, you are VERY wrong here. There is no 
"even" and no guessing. The "string" DOES include a terminating '\0'. It 
is EQUIVALENT to {'s', 't', 'r', 'i', 'n', 'g', '\0'}. And it contains 
SEVEN characters. Please, re-read your K&R. Specifically, the Section 
"Initialization" in the "Function and Program Structure" chapter (section 
4.9 in my copy), the paragraph about initialization with a string, which I 
quoted in an earlier email.

And, Stefan, there is a perfect way to specify a "0123" without the '\0' - 
{'0', '1', '2', '3'}.

Thanks
Guennadi
---
Guennadi Liakhovetski
