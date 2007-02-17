Return-Path: <linux-kernel-owner+w=401wt.eu-S964839AbXBQXEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964839AbXBQXEl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 18:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964848AbXBQXEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 18:04:41 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:53145 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964839AbXBQXEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 18:04:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uK3pcm79ortWuXpNzgaw572qgl7aEWQfGA6wt9ouAb+yz8EPrFOO6F59gMZQWjZ6p3lGsT90TvS8nisNZwBZh27i/o5j6w2zqG3R0YXKQXt3TQsfwb6SdfY4vEUaNtFIscnwDhUy14T7eNeSg/Id+yN2Xk9JRnujSjosFDgIbfc=
Message-ID: <f2b55d220702171504v1738d8fpb666a70be3a018c1@mail.gmail.com>
Date: Sat, 17 Feb 2007 15:04:39 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: mr.fred.smoothie@pobox.com
Subject: Re: GPL vs non-GPL device drivers
Cc: davids@webmaster.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
In-Reply-To: <161717d50702171418w2eecc38bse12df666e974a08b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <161717d50702160912x6dc4efbahcfb02f665ae3ec8a@mail.gmail.com>
	 <MDEHLPKNGKAHNMBLJOLKIEIMBKAC.davids@webmaster.com>
	 <161717d50702171418w2eecc38bse12df666e974a08b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/17/07, Dave Neuer <mr.fred.smoothie@gmail.com> wrote:
> I think you are reading Lexmark wrong. First off, Lexmark ruled that
> scenes a faire applied to the toner-level calculation, not "make a
> toner cartridge that works with a particular Lexmark printer." It was
> the toner-calculation algorithm that could't be done any other sane
> way, which made the TLP unprotectable via copyright. The opinion says,
> "Both prongs of the infringement test, in other words, consider
> 'copyrightability,' which at its heart turns on the principle that
> copyright protection extends to expression, not to ideas."

David S. is reading Lexmark right (IMHO, IANAL).  The byte-for-byte
content of the TLP had to be copied in order to interoperate with the
printer, because the printer checksummed it (apparently using SHA-1,
but possibly truncating the result to 8 bits, which is rather comical;
it is not 100% clear to me based on the appellate decision, which also
seems to say that the printer cartridge contains the SHA-1 algorithm,
which is probably just an error).  That rendered it a "lock-out code"
within the sense of Sega v. Accolade, and ultimately that's why the
circuit court vacated the district court's decision in Lexmark's
favor.

In order to vacate and remand, the appellate court had to demonstrate
that the district court's grant of preliminary injunction to Lexmark
was wrong _as_a_matter_of_law_.  So they had to construe the facts of
the case in a light as favorable to Lexmark as humanly possible.  They
concluded that, _even_ if the TLP contained copyrightable expression,
and _even_ if all of the district court's reasoning about the other
prongs of a preliminary injunction test (potential for irreparable
harm, balance of harms, the public interest) were correct, neither the
Copyright Act nor the DMCA could be used to establish the fourth
prong: likelihood of success on the merits.

Cloners rejoice:  the US Supreme Court has, by denying certioriari on
Judge Sutton's opinion, given you carte blanche to copy and distribute
freely any software or firmware whose author has been so stupid as to
cryptographically checksum it as an anti-interoperability measure.
Using copyrighted software as a "lock-out code" to create a cause of
action against reverse engineers has the paradoxical effect of
rendering it uncopyrightable _as_a_matter_of_law_ in the US, unless
and until Congress or a later Supreme Court creates new law to the
contrary.  I am not a lawyer, this is not legal advice, on your own
head be it.

> You're saying that there's no other way to interface device drivers to
> an operating system than the current Linux driver model? That's
> strange, since it's a different driver model than Linux had
> previously, and it's also different from the BeOS driver interface,
> etc. If the Linux driver interface is protectable, it doesn't seem
> like scenes a faire applies.

The Linux driver interface is, as a matter of law, not copyrightable
in the U. S. of A., no matter how many EXPORT_SYMBOL_GPLs and dactylic
hexameters you adorn it with.  That was already true under Baker v.
Selden, and didn't get any less so as a result of Lotus v. Borland,
and is now inescapable (IMHO) under Lexmark, and it's not likely to
get any less true unless RMS is elected president and appoints Eben
Moglen to the Supreme Court.  Sorry, folks; I'm just the messenger.

Cheers,
- Michael
