Return-Path: <linux-kernel-owner+w=401wt.eu-S1764917AbXHLBw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764917AbXHLBw6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 21:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756962AbXHLBwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 21:52:50 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:65099 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998AbXHLBwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 21:52:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rjad1Dl6P2Ye9xbB4kx+cZkh3Iwd+vrIal4ME+t6cfNbpzLBLGTC5Ka+tAJJIeKptB5j/DDQPS8x0LeHI7eb495HhxZm1BBRhWRdXGEtVkiipFT0samspwIW10WzKzV0Fc3wbSeuNKYs90Pig01mXGcUuoc28B9yK8LBbKyGWnA=
Message-ID: <9a8748490708111852y569a3e18i1c3d192e60eceafe@mail.gmail.com>
Date: Sun, 12 Aug 2007 03:52:48 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: Are we properly prepared to handle 3 Socket setups?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <46BE621E.9090509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8748490708111808o11d354fr9efa719bc38046c5@mail.gmail.com>
	 <46BE621E.9090509@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/07, Rene Herman <rene.herman@gmail.com> wrote:
> On 08/12/2007 03:08 AM, Jesper Juhl wrote:
>
> > This may be a little off topic, but I think it's interresting enough
> > to warrent a single mail.
> >
> > I just saw a news article (http://www.theinquirer.net/?article=41610)
> > about a 3 Socket Opteron motherboard and couldn't help but wonder if
> > we are prepared to deal with such a beast, so I thought I'd inform
> > everyone :-)
> >
> > I'm guessing equipping such a board with 3 single core CPU's could
> > show up some interresting corner cases in schedular code and
> > elsewhere, I'll bet we have some assumptions somewhere about
> > nr_of_cpus being an even number...
>
> I would hope the N=1 case will have flushed out enough of those... :-|
>
Hehe, true, but I was thinking more of nr_of_cpus is an odd number > 1. :-)
Just thinking of having to divide things by 3 makes me worry ;-)  ...

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
