Return-Path: <linux-kernel-owner+w=401wt.eu-S933370AbYBHThc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370AbYBHThc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 14:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbYBHThZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 14:37:25 -0500
Received: from keil-draco.com ([216.193.185.50]:50699 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbYBHThY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 14:37:24 -0500
From: Daniel Hazelton <dhazelton@enter.net>
To: David Newall <davidn@davidnewall.com>
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Date: Fri, 8 Feb 2008 14:36:52 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Marcel Holtmann <marcel@holtmann.org>, Greg KH <greg@kroah.com>,
       Christer Weinigel <christer@weinigel.se>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20080125180232.GA4613@kroah.com> <47ACA204.7030702@davidnewall.com> <47ACA8A5.9010807@davidnewall.com>
In-Reply-To: <47ACA8A5.9010807@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802081436.53928.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 February 2008 14:08:21 David Newall wrote:
> I explained something poorly:
> > Now, Alan has made a big issue over numerous legal opinions he has
> > received, but he's been completely coy in the details.
>
> The point I wanted to make is that a few people have said that lawyers
> say that kernel modules are derivative, but I only remember Alan saying
> that he had actually spoken with the lawyers.  Therefore I infer that
> this somewhat widely held opinion originates from him.  My point was to
> those people who have been taking him at his word, and was to point out
> that there are more reliable and transparent sources.  Don't take his
> word on it.  Take the words of real experts in the law, because instead
> of a mere four word conclusion, they explain everything.

The one technically inclined lawyer that I asked about this said that the 
Lexmark decision meant that code using an API did not mean the work was a 
derivative of the API. However, in the case of the Linux Kernel, the code is 
meant to function inside a much larger framework and the API available to 
modules includes large amounts of "boilerplate code" buried behind handy 
chunks of code like "list_for_each".

The problem, he said, was that, in the US, such code is included in the module 
in a mechanical and wholly automated process. Which means that the module 
doesn't automatically inherit the GPL license. But, he cautioned me, this 
does not mean that a court couldn't (and/or wouldn't) rule that a module 
written specifically for Linux is a derivative of the kernel.

He also cautioned that, although the Bern Convention broadly controlled 
international copyright laws, specific countries do seem to have laws that 
cover the "kernel module" situation much better than the US laws and that 
those laws do apparently  make a module a derivative of the kernel.

His overall statement on it was that, in his opinion, whether a given module 
is a derivative or not would depend on the amount of "original" work 
contained in it compared to the number of places where linux specific code is 
used. He also stated that, while disagreeing with the idea that parts of an 
API could be "so deeply embedded that using them creates a derivative work", 
it would be a good idea to always pay attention to the beliefs of the 
developers of the code, because it is their opinion that will start the legal 
problems.

In other words "EXPORT_SYMBOL_GPL" isn't his idea of "a good legal idea", but 
people ignoring this and doing things that circumvent this will, eventually, 
have problems with the people who hold the copyright on the code. (In 
addition, he stated that circumventing the "EXPORT_SYMBOL_GPL" bit might also 
be in violation of the DMCA, but he isn't sure if a court would see it in the 
same light as someone cracking the CSS key on a DVD expressly for the purpose 
of creating pirated copies)

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
