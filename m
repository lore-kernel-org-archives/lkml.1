Return-Path: <linux-kernel-owner+w=401wt.eu-S939954AbXHIQub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939954AbXHIQub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 12:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763581AbXHIQuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 12:50:15 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:38489 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146AbXHIQuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 12:50:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Do+KXmUCHPwmGtdTETr2NhAIqFQ3nSVwWirjHcJqEFRAmNoVybZZqOwMiXy649rk2ELH47HoBlovUx0DSImnPGzt1pCH5QM+jM81UHluU/UI50hKYQH4G2VnBhDSePdRzyME62od0yKIPNoFXBjmGUp1Dx9B06g2GQJb/+QcCFI=
Message-ID: <9a8748490708090950v2e38a250t24105acb6525acfe@mail.gmail.com>
Date: Thu, 9 Aug 2007 18:50:10 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [PATCH 2/3] UIO: Documentation
Cc: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       linux-kernel@vger.kernel.org, "Hans J. Koch" <hjk@linutronix.de>
In-Reply-To: <20070809071932.GA22318@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070718232332.GA4620@kroah.com>
	 <11848012053678-git-send-email-gregkh@suse.de>
	 <11848012122374-git-send-email-gregkh@suse.de>
	 <9a8748490708081436g23c8f01cga585d6612b380f16@mail.gmail.com>
	 <14166.1186611154@turing-police.cc.vt.edu>
	 <9a8748490708081603k65746311sad595947fd5ab971@mail.gmail.com>
	 <20070809071932.GA22318@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/07, Greg KH <gregkh@suse.de> wrote:
> On Thu, Aug 09, 2007 at 01:03:39AM +0200, Jesper Juhl wrote:
> > >
> > I think the only way to avoid it is to not provide something like UIO.
>
> Problem is, things like UIO provide a real solution for a wide range of
> different types of devices.  Like the one provided in the kernel right
> now, and a bunch of others that I am currently discussing with different
> manufacturers (think high-speed DSPs that just want to give userspace
> direct access to the card and have the kernel get the hell out of the
> way so data can be read and processed as fast as possible.)
>
Please understand that I'm not saying UIO isn't potentially useful,
nor am I saying that it won't potentially give us support for a bunch
of new hardware.  All I'm trying to say is that, to me at least, it is
trying to buy us those new drivers in a way that encourages creating
those drivers as closed source software- *that* is all I'm having
issues with - that is what I think is a step backwards - something
that may give us a short-term gain but will make us lose out
long-term.

> And also realize that some types of systems have been doing this very
> same kind of kernel/userspace interface for many years, namely X :)
>
That something has been going on for years doesn't in itself make it a
good argument for that model.  ;-)

> As for the legalities of using closed source userspace code with the UIO
> interface, consult a lawyer if you have questions, and be sure to bring
> up Alan's comments about derivative works :)
>
I'm not arguing against closed source applications in userspace. That
is of course OK. What I'm arguing about is a kernel interface that
encourages closed source (userspace) *drivers*.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
