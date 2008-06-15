Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbYFOCQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbYFOCQ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 22:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394AbYFOCQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 22:16:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755391AbYFOCQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 22:16:48 -0400
Date: Sat, 14 Jun 2008 19:15:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, bunk@kernel.org,
       akpm@linux-foundation.org, protasnb@gmail.com
Subject: Re: 2.6.26-rc6-git2: Reported regressions from 2.6.25
In-Reply-To: <20080614.180703.147133112.davem@davemloft.net>
Message-ID: <alpine.LFD.1.10.0806141910280.2949@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0806141423500.2949@woody.linux-foundation.org> <20080614.163129.80352314.davem@davemloft.net> <alpine.LFD.1.10.0806141727390.2949@woody.linux-foundation.org> <20080614.180703.147133112.davem@davemloft.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 14 Jun 2008, David Miller wrote:
> 
> So right now I'd say that the IA64 case could definitely be a match
> but the SSH case very much is not.

Ok. The only reason I matched up the ssh case was because it was reported 
to fix the stuck connections that Ingo had with distcc-over-loopback, so I 
thought the stuck-ssh thing could be the same.

But if you are sure ssh doesn't trigger the same thing, I really didn't 
have anything else to go on than "stuck TCP connection sounds familiar".

		Linus
