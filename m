Return-Path: <linux-kernel-owner+w=401wt.eu-S932875AbXBTK6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875AbXBTK6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 05:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932876AbXBTK6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 05:58:33 -0500
Received: from wx-out-0506.google.com ([66.249.82.228]:21601 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875AbXBTK6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 05:58:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nkMZveTGWc62gQpIrCPXkYNGw5hrXXGZemoQsq4KR5aGauhefgeurFgB9j+BR2px8xphy3atc4gkey36cHUIcuQpCIW6c1m0jBiSsgPN9ycMqivK12l6XmCSH4X5ga4MsBR0NVr5JoVlt8rDkuzNnywsgCRzv2H4Jgxq+xKom3k=
Message-ID: <3a5b1be00702200258r2b06dd98ibbb59af2ab346973@mail.gmail.com>
Date: Tue, 20 Feb 2007 16:28:31 +0530
From: "Komal Shah" <komal.shah802003@gmail.com>
To: Maximus <john.maximus@gmail.com>
Subject: Re: irqdesc porting help
Cc: "Paul Mundt" <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       arjan@infradead.org
In-Reply-To: <3a5b1be00702200254t1afd1c52u2e7401a4ab6c240f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3634de740702142231k938a4c5ic824c2eefc95c1b0@mail.gmail.com>
	 <20070215103347.GA18690@linux-sh.org>
	 <3634de740702192303xea41f14i9f613fac2725b0ca@mail.gmail.com>
	 <3a5b1be00702200254t1afd1c52u2e7401a4ab6c240f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/20/07, Komal Shah <komal.shah802003@gmail.com> wrote:
> Maximus,
>
> On 2/20/07, Maximus <john.maximus@gmail.com> wrote:
> > Hi,
> >   Sorry for the late response, attached is the code im trying to port
> > to linux - 2.6.20.
> >
> >
>
> Have you checked http://source.mvista.com/git linux-omap-2.6 git tree.
> Syed Khasim has already submitted this OMAP2430 TWL4030 chip core
> driver there, which is already synced with 2.6.20.
>

I just checked that code, and there is a line like:

393 /*
394 * Earlier this was desc->triggered = 1;
395 */
396 desc->status = IRQ_INPROGRESS;

So, I hope this helps, but still need to check its correctness.

-- 
---Komal Shah
http://komalshah.blogspot.com
