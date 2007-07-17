Return-Path: <linux-kernel-owner+w=401wt.eu-S937151AbXGQXj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937151AbXGQXj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 19:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761093AbXGQXjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 19:39:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:60310 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824AbXGQXjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 19:39:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kfbbb2meCNnG6Xku5Ki4tmbD0W7esVCM5TtGDB61VoRiCW51fQ8n3zhXZqYji6bkJetyQFs/fCY6+uOe6T5pUXkSurK5yd+gX2u+1ex8JW00dWL5nOT/SmXaxeJJ2E+oY+Fs+GwEsCznxCTUT/c9Cev2FpRAtrAeeJg20mzinvw=
Message-ID: <9a8748490707171639r41c085bfh857c5047a792dd0@mail.gmail.com>
Date: Wed, 18 Jul 2007 01:39:09 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "William Lee Irwin III" <wli@holomorphy.com>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Ray Lee" <ray-lk@madrabbit.org>,
       "Rene Herman" <rene.herman@gmail.com>, "Bodo Eggert" <7eggert@gmx.de>,
       "Matt Mackall" <mpm@selenic.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "David Chinner" <dgc@sgi.com>, "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <20070717170127.GJ11781@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8Gj55-hJ-5@gated-at.bofh.it> <8GtnN-7TG-23@gated-at.bofh.it>
	 <8GVjY-PL-25@gated-at.bofh.it> <E1IA7j1-0000j9-I3@be1.lrz>
	 <469A5D7C.5010904@gmail.com>
	 <Pine.LNX.4.58.0707161523500.25779@be1.lrz>
	 <469BF104.1040703@gmail.com>
	 <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>
	 <20070716235438.1bdd0722@the-village.bc.nu>
	 <20070717170127.GJ11781@holomorphy.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/07, William Lee Irwin III <wli@holomorphy.com> wrote:
> At some point in the past, I wrote:
> >> If at some point one of the pro-4k stacks crowd can prove that all
> >> code paths are safe, or introduce another viable alternative (such as
> >> Matt's idea for extending the stack dynamically), then removing the 8k
> >> stacks option makes sense.
>
> On Mon, Jul 16, 2007 at 11:54:38PM +0100, Alan Cox wrote:
> > Any x86-32 path unsafe with 4K stacks is almost certainly unsafe with 8K
> > stacks because the 8K stacks do not have seperate IRQ stack paths, so you
> > have the same space but split. It might be less predictable on 8K stacks
> > but it isn't absent.
>
> At hch's suggestion I rewrote the separate IRQ stack configurability
> patch into one making IRQ stacks mandatory and unconfigurable, and
> hence enabled with 8K stacks.
>
For what it's worth, that sounds good to me - like something that we
would want merged.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
