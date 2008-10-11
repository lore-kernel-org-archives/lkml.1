Return-Path: <linux-kernel-owner+w=401wt.eu-S1760327AbYJKW4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760327AbYJKW4I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 18:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbYJKWz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 18:55:59 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:51690 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbYJKWz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 18:55:58 -0400
Date: Sat, 11 Oct 2008 23:55:54 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Willy Tarreau <w@1wt.eu>
cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org
Subject: Re: Looks broken to me: x86, cyrix: debug
In-Reply-To: <20081011224816.GL24654@1wt.eu>
Message-ID: <alpine.LFD.1.10.0810112351300.1984@ftp.linux-mips.org>
References: <200810112003.m9BK3Wwu025556@hera.kernel.org> <20081011214043.283a3330@lxorguk.ukuu.org.uk> <alpine.LFD.1.10.0810112146400.1984@ftp.linux-mips.org> <20081011205858.GA21965@elte.hu> <20081011224816.GL24654@1wt.eu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Oct 2008, Willy Tarreau wrote:

> In fact the whole commit looks buggy to me as it simply reintroduces the
> old bug at several places. The correct way of accessing the registers is
> precisely through the inline functions and never through a macro due to
> the ordering problem.

 Well, with some GCC extensions macros can be written such that ordering 
is kept, but inline functions tend to be simpler and often more readable.

  Maciej
