Return-Path: <linux-kernel-owner+w=401wt.eu-S1760618AbYDCCvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618AbYDCCvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 22:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758218AbYDCCvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 22:51:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757896AbYDCCvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 22:51:12 -0400
Date: Wed, 2 Apr 2008 19:51:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, josh@freedesktop.org
Subject: Re: [PATCH 7/7] asm-generic: suppress sparse warning in ioctl.h
In-Reply-To: <20080403015946.GX9785@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.1.00.0804021950260.14670@woody.linux-foundation.org>
References: <1207182818.5740.26.camel@brick> <alpine.LFD.1.00.0804021752040.14670@woody.linux-foundation.org> <20080403013420.GV9785@ZenIV.linux.org.uk> <alpine.LFD.1.00.0804021848140.14670@woody.linux-foundation.org>
 <20080403015946.GX9785@ZenIV.linux.org.uk>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 3 Apr 2008, Al Viro wrote:
> 
> Um...  But that's _not_ a link-time constant - simply an int variable not
> defined in any object file...

Ahh, you're right, my bad. We could change it to take the address of it, 
though. I assume gcc is happy with that too?

			Linus
