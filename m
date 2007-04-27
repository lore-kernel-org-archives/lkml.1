Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbXD0WI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbXD0WI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 18:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757463AbXD0WIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 18:08:54 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757455AbXD0WIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 18:08:51 -0400
Date: Fri, 27 Apr 2007 15:08:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <200704280004.47683.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.98.0704271506080.9964@woody.linux-foundation.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704272324.43359.rjw@sisk.pl>
 <alpine.LFD.0.98.0704271442160.9964@woody.linux-foundation.org>
 <200704280004.47683.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Apr 2007, Rafael J. Wysocki wrote:
> 
> We're freezing many of them just fine. ;-)

And can you name a _single_ advantage of doing so?

It so happens, that most people wouldn't notice or care that kmirrord got 
frozen (kernel thread picked at random - it might be one of the threads 
that has gotten special-cased to not do that), but I have yet to hear a 
single coherent explanation for why it's actually a good idea in the first 
place.

And it has added totally idiotic code to every single kernel thread main 
loop. For _no_ reason, except that the concept was broken, and needed more 
breakage to just make it work.

		Linus
