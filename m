Return-Path: <linux-kernel-owner+w=401wt.eu-S1760544AbYG2VET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760544AbYG2VET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 17:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbYG2VEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 17:04:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754234AbYG2VEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 17:04:09 -0400
Date: Tue, 29 Jul 2008 14:01:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux v2.6.27-rc1: problem with firmware stuff
In-Reply-To: <200807292301.36987.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.10.0807291359110.3334@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org> <200807292249.48050.rjw@sisk.pl> <200807292301.36987.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 Jul 2008, Rafael J. Wysocki wrote:
> 
> Actually, this happened due to some firmware files being created as root during
> installations of pre-rc -git kernels from the O= directory.  So, not a real
> problem, but somewhat confusing.

Yeah, I've had that happen myself. It used to be that "make 
modules_install" (as root, obviously) would try build a new version of the 
kernel, and as a result subsequent build attempts would fail horribly 
because of various random files being now owned-by-root.

I don't know if there is a whole lot we can do about it in general..

			Linus
