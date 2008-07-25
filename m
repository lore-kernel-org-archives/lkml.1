Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbYGYVqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbYGYVqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 17:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbYGYVqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 17:46:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:59238 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbYGYVqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 17:46:45 -0400
Subject: Re: CONFIG_FRAME_POINTER [was [PATCH] x86: BUILD_IRQ say .text]
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Linuxppc-dev@ozlabs.org
In-Reply-To: <Pine.LNX.4.64.0807251839190.20617@blonde.site>
References: <Pine.LNX.4.64.0807211828470.26173@blonde.site>
	 <20080724104459.GI28817@elte.hu>
	 <Pine.LNX.4.64.0807251839190.20617@blonde.site>
Content-Type: text/plain
Date: Sat, 26 Jul 2008 07:46:13 +1000
Message-Id: <1217022373.11188.115.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-25 at 19:45 +0100, Hugh Dickins wrote:
> 
> I've Cc'ed Ben and linuxppc-dev because I wonder if they're aware
> that several options (I got it from LATENCYTOP, but I think LOCKDEP
> and FTRACE and some others) are doing a "select FRAME_POINTER",
> which forces CONFIG_FRAME_POINTER=y on PowerPC, even though
> FRAME_POINTER is not an option offered on PowerPC.  The
> resulting kernels appear to run okay, but I was surprised.

Because the option just does nothing for us ? :-) We always have frame
pointers on powerpc except in some case for leaf functions. I don't know
if the option has any actual effect on the later, but I don't think we
have a case where doing either way would break things.

Cheers,
Ben.


