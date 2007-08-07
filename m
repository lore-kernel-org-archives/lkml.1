Return-Path: <linux-kernel-owner+w=401wt.eu-S934073AbXHGD36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934073AbXHGD36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 23:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933406AbXHGD3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 23:29:48 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:8699 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933373AbXHGD3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 23:29:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FnEocRZIkb0WB+8XOEso2b15Uv1Z0meMcHA2nuskyM7594xyVnyiKHqV0a7ElTrixtYQAfCsOU50wqPhvnbhI3CHfI/rgW5Igg0Au2ovuo2kc3HQ0EBcJiIgPn9xsR3BrVetWiauuXJce6V2prDEN0O0/3Ld+7siOapCFqpUYsI=
Message-ID: <b4e196fa0708062029x681fafe7hc493c774a936cdf3@mail.gmail.com>
Date: Tue, 7 Aug 2007 13:29:46 +1000
From: "Nathan Williams" <ngwilliams@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_LICENSE usage
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKOEOJFOAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b4e196fa0708060053x65f0b1d3m50c62206cb65e016@mail.gmail.com>
	 <MDEHLPKNGKAHNMBLJOLKOEOJFOAC.davids@webmaster.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> b) if the binary blob is really a library to be run in kernel (host)
> space then there is no point in writing such driver - there are
> completely open-source drivers for ADSL devices and most (if not
> all) people will prefer them over any binary library.
>
> Perhaps you can convince the chipset manufacturer to open the source
> or publish the complete docs, but I wouldn't count on it.
> --
> Krzysztof Halasa
>

The binary blob is run in the kernel.  I wasn't aware of any
completely open-source drivers for ADSL modems, mine is a PCI ADSL
modem.  I have been referred to the BeWAN PCI driver as a guide for
conforming to GPL, but they use a binary library as well.

> I don't see any reason you cannot include the line 'MODULE_LICENSE("GPL")'
> in the source code for your module so long as that source code is not a
> derivative work of the binary. Whether or not you can distribute the
> resulting binary is, however, a complex legal question.
>
> > Additionally, I'm unsure of what is the meaning of
> >
> > "GPL and additional rights"     [GNU Public License v2 rights and more]
> >
> > Is it correct to say that my driver is licensed under GPL with
> > additional rights to use the binary library file?
>
> No. The "additional right" to use the binary library file is not a right
> under which your driver is licensed, so there are no additional rights to
> your driver. The binary library itself is offered under rights much less
> than the GPL.
>
> What exactly is the license under which the binary is offered? If it's "may
> be used with your driver" then you may have some interesting GPL issues when
> people want to modify your driver and continue to use the binary firmware
> with it.
>
> Does this "binary library" actually run on the host computer? Or is it
> firmware that runs on the modem only? Does it actually link in to the
> driver?
>
> DS

My company has been given documentation and the library source under
the terms of an NDA with the chipset manufacturer.  We are permitted
to compile the library and distribute the resultant binary blob, but
not release the source to the library.

The binary blob is linked into the driver we have written.  We don't
distribute this compiled module, customers are given the driver source
and the library blob, which they compile themselves.

Thanks for the help.

Nathan
