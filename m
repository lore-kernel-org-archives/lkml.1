Return-Path: <linux-kernel-owner+w=401wt.eu-S1031239AbXDZO5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031239AbXDZO5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 10:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031242AbXDZO5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 10:57:54 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:47659 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031239AbXDZO5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 10:57:53 -0400
Message-ID: <4630BD61.2050006@gmail.com>
Date: Thu, 26 Apr 2007 16:55:29 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
References: <20070404150231.GE27660@stusta.de> <4613C963.6070409@gmail.com> <20070404170016.453d26f1@the-village.bc.nu> <4613D492.2070404@gmail.com> <462C7D74.60003@gmail.com> <1177327476.17026.75.camel@localhost.localdomain> <Pine.LNX.4.64.0704230748270.25463@localhost.localdomain> <462CA764.5080401@gmail.com> <20070425181856.42fcfeb4.akpm@linux-foundation.org> <463081E5.5010306@gmail.com> <20070426135426.GM3468@stusta.de>
In-Reply-To: <20070426135426.GM3468@stusta.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2007 03:54 PM, Adrian Bunk wrote:

> Let me try to summarize the points:
> - you think MODULE_AUTHOR without MODULE_MAINTAINER confuses users

Yes, and the frustration of composing lengthy emails to bouncing (or worse 
still, silent) email adresses is severe if you just decided to for once not 
shrug about it but submit a bugreport. If it happens to an address from 
MAINTAINERS (and an LKML savvy user) the address can at least be deleted but 
you can't delete a MODULE_AUTHOR tag.

Without something like a MODULE_MAINTAINER I have no way of saying "ignore 
those MODULE_AUTHORs please, I want the bugreport".

> - Alan wants MODULE_AUTHOR to stay for easing showing authorship of code
>   to people
> - I (and others) think MODULE_MAINTAINER wouldn't make sense

Had a few Ays as well. But note, since you suggested removing MODULE_AUTHOR 
I actually agree that made more sense. It's just that iff that can't happen, 
I feel I need a place to override MODULE_AUTHOR for the use that I'm 
interested in and which is acting as the contact for a driver.

> Is there any good solution for this?
> E.g. modinfo could be changed to no longer defaulting to show the author?

Tie Alan to his chair and take away his keyboard while we submit patches 
removing MODULE_AUTHOR? Or just apply a trivial two line, optional, non 
mandatory, patch introducing a MODULE_MAINTAINER? You pick... :-)

Rene.

