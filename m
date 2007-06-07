Return-Path: <linux-kernel-owner+w=401wt.eu-S1763740AbXFGQis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763740AbXFGQis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbXFGQik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:38:40 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:9156 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbXFGQij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:38:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=l04CfNSGZ+hWJUzs86k8aaEvAKmc1W6ejLgn2D/JvrvjNq/CjnC9AHHQr2Cw0XfnELGbjW1T51VjeCip625NLm4KNL4FE1osFikvypvUDsEwJUB9kxzCEMdtAGFzJrxx2Cov3wGeiq77iZ156SrN8ZQDuZ0JTDSfcYezgt9SnDg=
Date: Fri, 8 Jun 2007 00:39:30 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: 2.6.22-rc4-mm1
Message-ID: <20070607163930.GA11060@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20070606020737.4663d686.akpm@linux-foundation.org> <20070606161936.GA8952@localhost.localdomain> <20070606110931.fda845de.akpm@linux-foundation.org> <20070607022608.GA2416@localhost.localdomain> <20070607055912.GX11166@waste.org> <20070607065158.GA1996@localhost.localdomain> <20070607140444.GR11115@waste.org> <20070607154007.GA9305@localhost.localdomain> <20070607155913.GW11115@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607155913.GW11115@waste.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 10:59:14AM -0500, Matt Mackall wrote:
>On Thu, Jun 07, 2007 at 11:40:08PM +0800, WANG Cong wrote:
>> On Thu, Jun 07, 2007 at 09:04:44AM -0500, Matt Mackall wrote:
>> >On Thu, Jun 07, 2007 at 02:51:58PM +0800, WANG Cong wrote:
>> >> >> Maybe there's something wrong with ketchup. ;(
>> >> >
>> >> >Can you do an 'lsdiff | grep lguest' on the patch in your ~/.ketchup directory?
>> >> >
>> >> >Ketchup simply applies patches, it never touches filenames directly.
>> >> >So for something to go wrong here and drop a file in the tree with a
>> >> >damaged pathname, you've either got a damaged patch, a bug in patch
>> >> >itself, or some form of filesystem corruption.
>> >> 
>> >> Thanks for your point.
>> >> 
>> >> It should be Documentation/lguest/lguest.c, maybe it was corrupted and ketchup
>> >> backuped it as mlguest.c.
>> >
>> >It'd be interesting to figure out how that happened, still.
>> >
>> >If your patch file is intact (are you using GPG's signature-checking
>> >support?), the most likely explanation is an operating system or
>> >filesystem bug.
>> 
>> Yes, I am using GPG's checking.
>
>Well that gives a pretty solid assurance that the patch you downloaded
>matches the one on kernel.org. And that one doesn't contain an
>mlguest.c. 
>

I agree.

>Ketchup doesn't even look inside patches, and patch doesn't invent
>names, so something in the bzip2 -> patch(1) -> filesystem chain got
>corrupted. Probably not bzip2, as it has CRCs.
>

Do you mean ketchup doesn't do anything if a file is corrupted?

>Do you have ECC memory?
>

No. Do you mean it's an error of my RAM? I have never met such things before,
how often does such kind of things happen? May be less often than a bug in
a stable kernel?

Thanks!

