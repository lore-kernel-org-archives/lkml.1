Return-Path: <linux-kernel-owner+w=401wt.eu-S1762553AbYJKUwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762553AbYJKUwe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 16:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760565AbYJKUwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 16:52:24 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:41432 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbYJKUwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 16:52:23 -0400
Date: Sat, 11 Oct 2008 21:52:18 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       torvalds@linux-foundation.org
Subject: Re: Looks broken to me: x86, cyrix: debug
In-Reply-To: <20081011214043.283a3330@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.1.10.0810112146400.1984@ftp.linux-mips.org>
References: <200810112003.m9BK3Wwu025556@hera.kernel.org> <20081011214043.283a3330@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Oct 2008, Alan Cox wrote:

> > +#define getCx86_old(reg) ({ outb((reg), 0x22); inb(0x23); })
> 
> Doesn't expand to any kind of returned value.

 Well, actually it returns the value of the inb() expression -- cf the 
semantics of compound statements.  The rest looks suspicious indeed.

  Maciej
