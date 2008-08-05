Return-Path: <linux-kernel-owner+w=401wt.eu-S1757401AbYHEFpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbYHEFpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 01:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbYHEF3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 01:29:32 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:1155 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbYHEF3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 01:29:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=Z3XK1Gntzsf134ochKm8rPt5PeXn1Y+7HdBPZbzhKN0DHo2SEDZ3ea8BQlnRGfepuI
         QdpeCr3tbsxBHDQehqrknaLE6IhIBiHYg75o1T0pvEtlrxGnBNotFOKlwHmFIZzJ6jEq
         cFuZ56RzH+aS0AFWD1CXLUhe21lBF8VLzcf/Q=
Message-ID: <3ae3aa420808042229l675ffd79p42a5691532b7ac3b@mail.gmail.com>
Date: Tue, 5 Aug 2008 00:29:30 -0500
From: "Linas Vepstas" <linasvepstas@gmail.com>
Reply-To: linasvepstas@gmail.com
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: amd64 sata_nv (massive) memory corruption
Cc: "John Stoffel" <john@stoffel.org>,
       "Alistair John Strachan" <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <489675DC.2080906@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.qB5d+HsAJ6G05jNoeU8Q9GV6Dow@ifi.uio.no>
	 <fa.fxlDAHxOnGgcBiOH/EOauE67ZPc@ifi.uio.no>
	 <fa.1WYUmN6FHR5yW+sXoYRFN22Y8S8@ifi.uio.no>
	 <fa.LAUkvEUlYiF69V/F8F3wigxqH9w@ifi.uio.no>
	 <fa.mXeFXYNkfZfUYPQcGwzok0IOIfY@ifi.uio.no>
	 <fa.KjbvCGbUr2JeQTcwA1/sFGIIMik@ifi.uio.no> <489675DC.2080906@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/3 Robert Hancock <hancockr@shaw.ca>:
> Linas Vepstas wrote:
>>
>> What I don't like is that the corruption was utterly silent --
[...]
>> So the question is: is there some sort of sata (or pci) "loopback mode",
>> where we could pump data through all of the busses and controllers, up
>> near to the point where it would normally go out to the serdes to the
>> disk,
>> but instead have it loop back, so that we could test the buses between
>> endpoints?
>
> I don't imagine that would be very useful in this case. The SATA link, PCI
> Express bus, HyperTransport bus all have parity or CRC error checking, so
> presumably they couldn't be likely to cause undetected errors. The
> transitions between them could cause problems,

Well, but I suffered badly from an undetected error, in the sense
that the operating system had no knowledge of it, and it corrupted
data on disk as a result. As Alan Cox suggests, perhaps I didn't
have EDAC turned on, or something ... I'm investigating now.
But this is moot -- if there is software that already exists that
could have reported the error to the kernel, then this software
should have been installed/enabled/operating by default.

> and most desktop machines
> don't have ECC memory which could catch memory timing problems or bad RAM

I'm unclear on ECC memory: if a motherboard "supports ECC",
does it mean it actually uses ECC bits in the bus between the
memory controller and the RAM?  Or does it simply mean that
it won't hang if I plug in ECC RAM (but otherwise ignore the bits)?

Personally I'm ready to pop $$$ for ECC it if will actually do
something for me, this has been painful.

--linas
