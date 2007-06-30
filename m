Return-Path: <linux-kernel-owner+w=401wt.eu-S1753109AbXF3EBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbXF3EBL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 00:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750721AbXF3EBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 00:01:03 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:44912 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750714AbXF3EBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 00:01:01 -0400
Date: Sat, 30 Jun 2007 06:01:23 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Dan Aloni <da-x@monatomic.org>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] automatic CC generation for patch submission
Message-ID: <20070630040123.GI6087@stusta.de>
References: <20070630023451.GA21593@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070630023451.GA21593@localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2007 at 05:34:51AM +0300, Dan Aloni wrote:
>...
> Basically, instead of manually figuring out who to add to CC
> when sending a patch to LKML by looking at MAINTAINERS, a 
> script can look at '.maintainers' files spread across the
> source tree and automatically generate a proper list of CCs
> for a patch.
>...
> To illustrate: If a patch affects a file under 
> drivers/net/e1000, the CC script will look at these files
> 
>   drivers/net/e1000/.maintainers
>   drivers/net/.maintainers
>   drivers/.maintainers
>   .maintainers
> 
> ... to gather up the mailing list addresses or an individual 
> maintainer inbox address.
>...
> Any comments?

As Auke said, maintaining the information in MAINTAINERS would be 
better.

And another important use case that shouldn't require much extra work 
would be to do the same for bug reports.

Generally, you should keep in mind that it must fit into the workflow of 
the people who should use it. E.g. I could imagine that it might make 
more sense if you write a small tool that takes a patch or a path and 
outputs email addresses instead of a huge tool that tries to solve too 
many problems at once and doesn't fit into the workflow of most people.

> Dan Aloni

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

