Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbZKBKNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbZKBKNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbZKBKNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:13:15 -0500
Received: from www84.your-server.de ([213.133.104.84]:53127 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832AbZKBKNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:13:12 -0500
Subject: Re: [PATCH] proc: remove /proc/*/status "Stack usage:"
From: Stefani Seibold <stefani@seibold.net>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20091102055638.GA2186@x200>
References: <20091101131518.GA18284@x200> <1257086397.31587.5.camel@wall-e>
	 <20091101155345.GA3867@x200> <1257118328.7978.9.camel@wall-e>
	 <20091102055638.GA2186@x200>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 02 Nov 2009 11:13:10 +0100
Message-ID: <1257156790.4492.4.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Poor embedded people!
> 

That's why embedded peoble don't like to contribute their work.

> There is even Documentation/vm/page-types.c which is trivially adapted
> to show stack pages state.
> 
> > Like Dr Frank. N. Furter in the "Rocky Horror Picture Show" says: remove
> > the cause but NOT the symptoms!
> 
> The root of the problem is that you're measuring badly defined value.
> 
> Kernel doesn't know SP register of a running task until it stops it.
> Even if task is stopped or inside kernel, kernel doesn't know where
> userpace stack starts, because, in theory, application can move it's
> stack to anywhere.
> 

It works fine for 99% percent of the use cases. Nothing is perfect,
especially in theory.

> > And the cause is the miss implemented KSTK_ESP in a x86_64. I also
> > checked all other architekture depended KSTK_ESP definitions and this
> > definitions looks okay for me. 

BTW: I had fixed the x86_65 KSTP_ESP implementation. I tested it with 32
bit and 64 bit user space application. I will send soon a patch. Thanks
for figure out the problem.

Stefani


