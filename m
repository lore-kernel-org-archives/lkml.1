Return-Path: <linux-kernel-owner+w=401wt.eu-S1759100AbZF2Jt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100AbZF2Jt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 05:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758793AbZF2Js6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 05:48:58 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:36668 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215AbZF2Js4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 05:48:56 -0400
Subject: Re: kmemleak hexdump proposal
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <84144f020906290243u7a362465p6b1f566257fa3239@mail.gmail.com>
References: <20090628173632.GA3890@localdomain.by>
	 <84144f020906290243u7a362465p6b1f566257fa3239@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 29 Jun 2009 10:48:42 +0100
Message-Id: <1246268922.21450.3.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jun 2009 09:48:43.0980 (UTC) FILETIME=[CA5418C0:01C9F89E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-29 at 12:43 +0300, Pekka Enberg wrote:
> On Sun, Jun 28, 2009 at 8:36 PM, Sergey
> Senozhatsky<sergey.senozhatsky@mail.by> wrote:
> > What do you think about ability to 'watch' leaked region? (hex + ascii).
> > (done via lib/hexdump.c)
> 
> What's your use case for this? I'm usually more interested in the
> stack trace when there's a memory leak.

I once had a need for such feature when investigating a memory leak (it
was more like debugging kmemleak) but a script combining dd, od
and /dev/kmem did the trick (I also work in an embedded world where I
have a halting debugger connected most of the times).

-- 
Catalin

