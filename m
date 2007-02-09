Return-Path: <linux-kernel-owner+w=401wt.eu-S1945971AbXBIA7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945971AbXBIA7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 19:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945966AbXBIA7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 19:59:36 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47698 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945971AbXBIA7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 19:59:35 -0500
Date: Thu, 8 Feb 2007 16:59:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <Pine.LNX.4.64.0702081632200.8424@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702081645020.8424@woody.linux-foundation.org>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702082202180.24888@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081324090.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081432320.27603@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0702081528070.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081554380.29559@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0702081632200.8424@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Feb 2007, Linus Torvalds wrote:
> 
> The C language clearly says that bitfields have implementation-defined 
> types.

Btw, this isn't even some "theoretical discussion". LOTS of compilers do 
unsigned bitfields. It may even be the majority. There may (or may not) be 
some correlation with what the default for "char" is, I haven't looked 
into it.

		Linus
