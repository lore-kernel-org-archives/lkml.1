Return-Path: <linux-kernel-owner+w=401wt.eu-S1758746AbYLLQgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbYLLQgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 11:36:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757545AbYLLQfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 11:35:53 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:42808 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757133AbYLLQfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 11:35:52 -0500
Subject: Re: Auto generate .config.
From: Jon Masters <jonathan@jonmasters.org>
To: Marcello Henrique <faraohh@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <f5cc88f60812120820i4252962er2fa6d3483c2ae412@mail.gmail.com>
References: <f5cc88f60812120747w47c762a7qcee62fdfa10d6ac6@mail.gmail.com>
	 <49428DF8.2090205@diamondcut.com.br>
	 <f5cc88f60812120820i4252962er2fa6d3483c2ae412@mail.gmail.com>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Fri, 12 Dec 2008 11:34:59 -0500
Message-Id: <1229099699.7923.4.camel@jcmlaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-12 at 14:20 -0200, Marcello Henrique wrote:

> I understand that this is possible, but would not be possible to
> generate one .config of modules that are running to compile a kernel
> optimized?
> 
> The idea is that the kernel of my distribution is too fat and I only
> generate a kernel module that I use automatically from a kernel fat.
> understand?

Several people have written scripts over the years to do this. I don't
have one handy, but I suspect the LKML (linux-kernel) archives know.

Note that module overhead is not /too/ bad these days. It used to be
that loading modules significantly affected boot time, but some recent
improvements have helped - including a few fixes to module-init-tools:
binary trie based index files (v3.5), shortened naming (v3.6), etc. I
think that, really, at this point module loading overhead is small.

Jon.


