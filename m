Return-Path: <linux-kernel-owner+w=401wt.eu-S1760482AbYDXPca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760482AbYDXPca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762532AbYDXPaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:30:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762579AbYDXPaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:30:20 -0400
Date: Thu, 24 Apr 2008 08:29:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] alternative to sys_indirect, part 1
In-Reply-To: <20080424112514.055d8071@the-village.bc.nu>
Message-ID: <alpine.LFD.1.10.0804240828100.2779@woody.linux-foundation.org>
References: <200804240403.m3O43us8028699@devserv.devel.redhat.com> <20080424112514.055d8071@the-village.bc.nu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 Apr 2008, Alan Cox wrote:
> 
> Given we will never have 2^32 socket types, and in a sense this is part
> of the type why not just use
> 
> 	socket(PF_INET, SOCK_STREAM|SOCK_CLOEXEC, ...)

Ok, I have to admit that I find this very appealing. It looks much 
cleaner, but perhaps more importantly, it also looks both readable _and_ 
easier to use for the user-space programmer.

		Linus
