Return-Path: <linux-kernel-owner+w=401wt.eu-S1945972AbXBIBLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945972AbXBIBLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 20:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945974AbXBIBLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 20:11:24 -0500
Received: from smtp.osdl.org ([65.172.181.24]:48216 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945972AbXBIBLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 20:11:23 -0500
Date: Thu, 8 Feb 2007 17:11:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <Pine.LNX.4.64.0702081643280.30166@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0702081705300.8424@woody.linux-foundation.org>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702082202180.24888@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081324090.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081432320.27603@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0702081528070.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081554380.29559@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0702081632200.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081643280.30166@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Feb 2007, David Rientjes wrote:
>
> Maybe you should read my first post, we're talking about gcc's behavior 
> here, not the C standard.

Give it up, David.

Even gcc DOES DIFFERENT THINGS! Have you even read the docs?

	By default it is treated as signed int but this may be changed by 
	the -funsigned-bitfields option.

So even for gcc, it's just a default. I think you can even change the 
default in the spec file.

		Linus
