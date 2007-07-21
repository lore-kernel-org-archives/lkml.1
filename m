Return-Path: <linux-kernel-owner+w=401wt.eu-S937694AbXGUON3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937694AbXGUON3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 10:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760448AbXGUONV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 10:13:21 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:54201 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757619AbXGUONU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 10:13:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jqXhxg5FXvcc+3DszBsNpacqeA1klho3Zw2dkYAKxiHknC/dklYYahRdGAIMQw9mcmMMn4Aqz7RQvj4lUv2RxhwNH8vaml9tlTS1Z9sIPfJqmwvqvHGtZCOsfd/WtoZdC3Kms/dqlhm0DGpkEpUr32jra3sG5hKsK45G5/h9nyw=
Message-ID: <7e5f60720707210713o4ff0825eu463abee77dc1f04c@mail.gmail.com>
Date: Sat, 21 Jul 2007 16:13:19 +0200
From: "Peter Bortas" <bortas@gmail.com>
To: "Adrian McMenamin" <adrianmcmenamin@gmail.com>
Subject: Re: [PATCH] Fix DMA on Dreamcast
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lethal@users.sourceforge.net, marcus@mc.pp.se
In-Reply-To: <92a12cdb0707210506t5cf58cc4gc5b70f335545dc3f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <92a12cdb0707191230g216feaf2ied3e95bacf4dd572@mail.gmail.com>
	 <20070720120408.1f190269.akpm@linux-foundation.org>
	 <92a12cdb0707210322m6670acaer768d078c5e358b0c@mail.gmail.com>
	 <7e5f60720707210424w48f9dc10hff044d702f7bd1d3@mail.gmail.com>
	 <92a12cdb0707210506t5cf58cc4gc5b70f335545dc3f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/07, Adrian McMenamin <adrianmcmenamin@gmail.com> wrote:
> On 21/07/07, Peter Bortas <bortas@gmail.com> wrote:
>
> >
> > Sidenote: Does Linux handle the Dreamcast DMA errata?
> >
>
> You need to explain what you mean (at least to me!).
>
> If you mean will it degrade gracefully - not without this patch if set
> to the (correct) defconfig. With iffy settings it will.

If I remember correctly (and that's a big if since I last looked at it
in 2001) some revisions of the Dreamcast hardware would sporadically
lock up if you scheduled a new DMA request to quickly after a previous
one, even if you checked the ready bit. It's worked around by a delay
of X microseconds as recommended by Sega engineers. I don't remember
the value of X, nor where exactly in the flow this workaround should
be applied.

Adding Marcus in case he has a better memory than me.

-- 
Peter Bortas
