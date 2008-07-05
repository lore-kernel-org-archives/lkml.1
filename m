Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbYGESkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbYGESkX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 14:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYGESkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 14:40:10 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44547 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbYGESkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 14:40:08 -0400
Date: Sat, 5 Jul 2008 20:40:07 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Peter Anvin <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>, linux-ia64@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: the printk problem
In-Reply-To: <alpine.LFD.1.10.0807051045520.2815@woody.linux-foundation.org>
Message-ID: <alpine.LNX.1.10.0807052039520.28765@fbirervta.pbzchgretzou.qr>
References: <20080705125230.GA20166@damson.getinternet.no> <alpine.LFD.1.10.0807051045520.2815@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2008-07-05 19:56, Linus Torvalds wrote:
>> >
>> > How about %p{feature}?
>
>No.
>
>I _expressly_ chose '%p[alphanumeric]*' because it's basically 
>totally insane to have that in a *real* printk() string: the end result 
>would be totally unreadable.

So, and what do you do when you run out of alphanumeric characters?
