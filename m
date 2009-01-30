Return-Path: <linux-kernel-owner+w=401wt.eu-S1757696AbZA3XIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696AbZA3XIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 18:08:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755771AbZA3XHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 18:07:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57920 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755684AbZA3XHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 18:07:53 -0500
Date: Fri, 30 Jan 2009 15:07:30 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Parag Warudkar <parag.lkml@gmail.com>,
       Matt Carlson <mcarlson@broadcom.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.29-rc3: tg3 dead after resume
In-Reply-To: <200901302354.27497.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0901301506520.3150@localhost.localdomain>
References: <alpine.DEB.2.00.0901281858380.5048@parag-desktop> <200901300110.56533.rjw@sisk.pl> <alpine.DEB.2.00.0901301730230.6574@parag-desktop> <200901302354.27497.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 Jan 2009, Rafael J. Wysocki wrote:
>
> Well, I'm not sure if tg3 is at fault, really.
> 
> What happens if you unload tg3 before suspend and load it back after the
> resume?

Yes, good thing to test. See my previous email - maybe it's a bridge.

		Linus
