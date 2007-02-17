Return-Path: <linux-kernel-owner+w=401wt.eu-S965114AbXBQJr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965114AbXBQJr5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 04:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965115AbXBQJr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 04:47:56 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:26917 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965114AbXBQJr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 04:47:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KQutGNmGxHsIRkiJtRrXbSwMEVFKAtHCSjKwUKLa5KBHKhAdFPRzqKckj/a0HkK2MgpUgmWf7P51S5RJAvPps7WHuDh7q9Y7D774w5M9p15ycvLAym8gq3Fus/8v664sPGaCav3znXsKiS6Fz3F31GSwaiWPsxDhhHxGE843bOs=
Message-ID: <45a44e480702170147x73d1e5c8v6439ac412b952a7@mail.gmail.com>
Date: Sat, 17 Feb 2007 10:47:54 +0100
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH/RFC 2.6.20-rc4 1/1] fbdev,mm: hecuba/E-Ink fbdev driver
Cc: "Andrew Morton" <akpm@osdl.org>, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <45A6DAA2.8070605@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070111142427.GA1668@localhost>
	 <20070111133759.d17730a4.akpm@osdl.org>
	 <45a44e480701111622i32fffddcn3b4270d539620743@mail.gmail.com>
	 <45A6DAA2.8070605@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/12/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> Jaya Kumar wrote:
> > - write so get page_mkwrite where we add this page to a list
> > - also schedules a workqueue task to be run after a delay
> > - app continues writing to that page with no additional cost
> > - the workqueue task comes in and unmaps the pages on the list, then
> >  completes the work associated with updating the framebuffer
>
> Have you thought about implementing a traditional write-back cache using
> the dirty bits, rather than unmapping the page?
>

Ah, sorry, I erred in my description. I'm not unmapping pages, I'm
calling page_mkclean which uses the dirty bits.

Thanks,
jaya
