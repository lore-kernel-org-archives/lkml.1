Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbXEGIHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbXEGIHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 04:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbXEGIHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 04:07:24 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:57015 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbXEGIHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 04:07:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H6xwzkThyIJxY4Q2IVr1LxSw2y9U0dTYmK+rgpShwcf1aNQrEgTLCI5F60QrEQOODx7ilyBdldrTEgYGGH5h3mHGMDjHexetxp7DRCSQg5s0nEnyn0WDusbhfw/jDLErA78e5Thh5Yk7oEJOWEUeOSoh//05D3GzkXtuo4QQUjk=
Message-ID: <5486cca80705070107s586b2431m65a3b22be5dca7eb@mail.gmail.com>
Date: Mon, 7 May 2007 10:07:21 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [Linux-usb-users] [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Paul Fulghum" <paulkf@microgate.com>,
       "Oliver Neukum" <oliver@neukum.org>, linux-kernel@vger.kernel.org,
       linux-usb-users@lists.sourceforge.net
In-Reply-To: <Pine.LNX.4.44L0.0705061744540.21407-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070506132849.62e1e218@the-village.bc.nu>
	 <Pine.LNX.4.44L0.0705061744540.21407-100000@netrider.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/6, Alan Stern <stern@rowland.harvard.edu>:
> On Sun, 6 May 2007, Alan Cox wrote:
>
> > > However, whatever policy the buffer uses, the fundamental point it's that
> > > when I flush the input buffer I should be sure that each byte read
> > > after the flush is *new* (current) data and not old one. This because
> >
> > Define "new" and "old" in this case. I don't believe you can give a
> > precise definition or that such a thing is physically possible.
>
> One can come close.  It would make sense to say that after a flush,
> subsequent reads should retrieve _contiguous_ bytes from the input stream.
> In other words, rule out the possibility that the read would get bytes
> 1-10 (from some buffer somewhere) followed by bytes 30-60 (because bytes
> 11-29 were dropped by the flush).  By contrast, it would be permissible
> for the read to obtain bytes 20-60, even though 20-29 may have been
> entered the input stream before the flush occurred.
>

You've expressed in an extremely clear way what I meant. Thanks.


Regards,

  ~ Antonio
