Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYLAUYC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYLAUYC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 15:24:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbYLAUXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 15:23:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486AbYLAUXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 15:23:50 -0500
Date: Mon, 1 Dec 2008 12:23:25 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
       randy.dunlap@oracle.com, greg@kroah.com, adobriyan@gmail.com,
       remi.colinet@gmail.com, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RESEND][PATCH] Add /proc/mempool to display mempool usage
In-Reply-To: <alpine.LFD.2.00.0812011210030.3256@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0812011221120.3256@nehalem.linux-foundation.org>
References: <1227980689.6354.24.camel@localhost.localdomain>  <20081129214207.GA6747@x200.localdomain>  <20081129234907.GA2340@kroah.com>  <20081201101245.0a2f3123.randy.dunlap@oracle.com>  <1228158811.3196.88.camel@calx>  <20081201120210.1ed16bd5.akpm@linux-foundation.org>
 <84144f020812011207q29fe4b3fq11a9e55f171cf743@mail.gmail.com> <alpine.LFD.2.00.0812011210030.3256@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Dec 2008, Linus Torvalds wrote:
> 
> The fact that something is documented (whether correctly or not) has 
> absolutely _zero_ impact on anything at all. What makes something an ABI 
> is that it's useful and available. The only way something isn't an ABI is 
> by _explicitly_ making sure that it's not available even by mistake in a 
> stable form for binary use.

Of course, the alternate form is to make it so _useless_ that people won't 
use it even if it's available, and I guess we do have those kinds of 
interfaces too. But we generally don't need to worry about unused and 
useless interfaces very much, so it doesn't tend to matter much.

			Linus
