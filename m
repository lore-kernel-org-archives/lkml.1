Return-Path: <linux-kernel-owner+w=401wt.eu-S1422780AbXCGSGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422780AbXCGSGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422975AbXCGSGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:06:40 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46322 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422780AbXCGSGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 13:06:39 -0500
Date: Wed, 7 Mar 2007 10:05:53 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Verych <olecom@flower.upol.cz>
cc: David Howells <dhowells@redhat.com>, Al Viro <viro@ftp.linux.org.uk>,
       akpm@linux-foundation.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, johannes@sipsolutions.net
Subject: Re: ALIGN via ilog2 without gccisms (Re: [PATCH] Fix get_order())
In-Reply-To: <20070307172449.GR16509@flower.upol.cz>
Message-ID: <Pine.LNX.4.64.0703071003300.5963@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703061913080.5963@woody.linux-foundation.org>
 <20070306173929.2708.37191.stgit@warthog.cambridge.redhat.com>
 <8543.1173267786@redhat.com> <E1HOybN-00031m-6M@flower>
 <Pine.LNX.4.64.0703070836220.5963@woody.linux-foundation.org>
 <20070307172449.GR16509@flower.upol.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Mar 2007, Oleg Verych wrote:
> 
> GCC's assembler version of this macro is optimized as needed.

Not fora non-constant mask, I bet.

> But i wanted to address Al's statement about using typeof():

Well, that doesn't affect ALIGN(), since you can only use ALIGN() on an 
arithmetic type anyway (and only within scope). So the odd corner cases 
with typeof leaking data outside of the scope is not an issue.

		Linus
