Return-Path: <linux-kernel-owner+w=401wt.eu-S1757024AbXFWLF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024AbXFWLF3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 07:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbXFWLFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 07:05:21 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:10320 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbXFWLFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 07:05:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fYpGWbo96HNuxwR7AKN+l1t4x1/SI/WOZ7x19Zg23qobO8GDSFAJifW4UW5+01Z34uVjQvFa1IJHbQe1DIbY5PQ0cGbuy4gQSb+xuYQ46+szFKQa4NfzujI2X/95u6iorD61DHc6boIIqzSGE2w1hdTYlE/hXNZJUB77EeJ+JrE=
Message-ID: <7b9198260706230405y5c4a173dx82a18fcc14a10272@mail.gmail.com>
Date: Sat, 23 Jun 2007 12:05:17 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Alberto Gonzalez" <info@gnebu.es>
Subject: Re: Question about fair schedulers
Cc: "Willy Tarreau" <w@1wt.eu>, "Paolo Ornati" <ornati@fastwebnet.it>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200706231300.18840.info@gnebu.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706230007.15622.info@gnebu.es>
	 <200706231245.30317.info@gnebu.es> <20070623105057.GD7070@1wt.eu>
	 <200706231300.18840.info@gnebu.es>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/06/07, Alberto Gonzalez <info@gnebu.es> wrote:
> On Saturday 23 June 2007, Willy Tarreau wrote:
> > On Sat, Jun 23, 2007 at 12:45:30PM +0200, Alberto Gonzalez wrote:
> > > Ok, so if I understand correctly, the problem I had in my simple test
> > > will be solved by distributions once a fair scheduler goes into mainline?
> >
> > No, there is no reason to wait for a fair scheduler at all. A *desktop*
> > distro *must* take process priorities into account, otherwise it's broken
> > by design.
>
> Well, right now with the mainline scheduler it works fine. The player gets
> more CPU time than the encoder. It was when I switched to -ck kernel (with a
> fair scheduler) that it didn't work correctly, that's why I asked about
> this "fair" concept in the first place.
>
> I guess once a fair scheduler goes mainline they will adapt things to work
> correctly again.
>
> > Regards,
> > Willy
>
> Cheers,
> Alberto.
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Alberto,

If you're feeling adventurous, grab the latest kernel and patch it
with Ingo's scheduler: CFS.

You may be pleasantly surprised.

-- 
Regards,
Tom Spink
University of Edinburgh
