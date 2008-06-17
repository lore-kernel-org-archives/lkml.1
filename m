Return-Path: <linux-kernel-owner+w=401wt.eu-S1759589AbYFQVgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589AbYFQVgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 17:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757123AbYFQVgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 17:36:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33075 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069AbYFQVgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 17:36:24 -0400
Date: Tue, 17 Jun 2008 22:36:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>, Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386,
	bisected, reproducable)
Message-ID: <20080617213618.GL28946@ZenIV.linux.org.uk>
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org> <alpine.LFD.1.10.0806171331460.2908@woody.linux-foundation.org> <alpine.LFD.1.10.0806171356320.2908@woody.linux-foundation.org> <485829A1.4020705@firstfloor.org> <alpine.LFD.1.10.0806171421100.2907@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806171421100.2907@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 02:24:39PM -0700, Linus Torvalds wrote:

> The whole *and*only* reason for copy_to/from_user() existing AT ALL is 
> exactly the fact that the source or destination access can fault. 

Erm...  The reason for copy_to_user() existing is that dereferencing
a user-supplied address in the kernel does not have to access any
memory reachable in user mode, regardless of any faults.  WTF are you
guys talking about?
