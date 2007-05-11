Return-Path: <linux-kernel-owner+w=401wt.eu-S934230AbXEKVdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934230AbXEKVdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 17:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759670AbXEKVdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 17:33:37 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45167 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758257AbXEKVdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 17:33:36 -0400
Date: Fri, 11 May 2007 22:35:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@stusta.de>
Cc: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       Rene Herman <rene.herman@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, randy.dunlap@oracle.com,
       akpm@linux-foundation.org, rpjday@mindspring.com, marcel@holtmann.org,
       hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module_author: don't advice putting in an email address
Message-ID: <20070511223500.01fe6596@the-village.bc.nu>
In-Reply-To: <20070511211823.GG7984@stusta.de>
References: <4643BDF2.9030105@gmail.com>
	<20070511114605.4c2698ec@the-village.bc.nu>
	<alpine.DEB.0.98.0705110740420.12363@sigma.j-a-k-j.com>
	<20070511211823.GG7984@stusta.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This still wouldn't solve the following problems:
> - I doubt it will be kept up to date for all > 2800 modules in the kernel
> - the 3 year old kernel of your distribution would contain 3 year old
>   maintainership information
> - maintainers sometimes disappear

Maintainers sometimes DON'T disappear ....
> 
> The default for "bug and defect reports" should be for all modules (as 
> well as for non-modular code) from ftp.kernel.org kernels either 
> linux-kernel or the kernel Bugzilla. [1]

If users put it in the kernel bugzilla its gets lost because most of the
bugzilla isn't set up to route bugs to maintainers. In the unlikely event
it arrives there or it gets posted to linux-kernel the only reply is
"report it to your distributor"

> For distribution kernels (which are what most users are using), the
> default for "bug and defect reports" should be the distribution support.

I'd prefer not. I get reports from people about drivers that got "lost"
by vendors, regularly. Nor am I pointing fingers at specific vendors here,
last month I sorted out a two year old "lost in Red Hat Bugzilla" kernel
bug for example.

Alan
