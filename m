Return-Path: <linux-kernel-owner+w=401wt.eu-S934796AbXEHWYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934796AbXEHWYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934779AbXEHWYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:24:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43403 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934778AbXEHWYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:24:33 -0400
Date: Wed, 9 May 2007 00:24:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Chris Wedgwood <cw@f00f.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [x86-64] Add getcpu and epoll_pwait system calls.
Message-ID: <20070508222432.GA15029@one.firstfloor.org>
References: <20070508185145.B9A8E1827261@tuatara.stupidest.org> <20070508221348.GC17482@one.firstfloor.org> <20070508221656.GA6850@tuatara.stupidest.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508221656.GA6850@tuatara.stupidest.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 03:16:56PM -0700, Chris Wedgwood wrote:
> On Wed, May 09, 2007 at 12:13:48AM +0200, Andi Kleen wrote:
> 
> > Nope.  There already is a getcpu vsyscall. This is not needed.
> 
> The kbuild magic that checks for missing syscalls needs to be taught
> about this then I take it?
> 

Somehow yes.  But i'm not going to add a useless syscall just to shut it up.

-Andi
