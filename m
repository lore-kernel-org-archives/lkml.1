Return-Path: <linux-kernel-owner+w=401wt.eu-S1759293AbYHCUTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293AbYHCUTx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 16:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbYHCUTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 16:19:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:39762 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008AbYHCUTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 16:19:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IeIJWsi7xSd0abDvNLfFyCHI5DCt/p9PtCqVPH8lI2oX5pPDuwiXm/Y3ZrxzACAbXW
         77dLDUlMLNPjnjnQ9jlD91/HLZeRo76wn6Plb4XrDZyWLPPIzPox8dQjro7IBtOt/ycU
         FnJ07tFGI/lYBCHtikL5meXHNOT0/ozYuch/s=
Message-ID: <58cb370e0808031319o748e570bo700873365ba22aa1@mail.gmail.com>
Date: Sun, 3 Aug 2008 22:19:40 +0200
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: Kernel Summit request for Discussion of future of ATA (libata) and IDE
Cc: "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
In-Reply-To: <20080803201719.576f85f6@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217779055.4179.10.camel@localhost.localdomain>
	 <20080803173941.314edf33@lxorguk.ukuu.org.uk>
	 <1217783433.4179.18.camel@localhost.localdomain>
	 <20080803194501.24fa3e51@lxorguk.ukuu.org.uk>
	 <1217791284.4179.34.camel@localhost.localdomain>
	 <20080803201719.576f85f6@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 3, 2008 at 9:17 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> I don't envisage anything in terms of code changes (or removal) coming
>> out of this.  What I would like is a nice roadmap of where to start for
>> people contemplating writing IDE drivers.
>
> For the vendors I've talked with the answer is usually "both". A libata
> driver for the future and current distributions, and an old IDE driver
> for older RHEL and SLES releases. Fortunately the driver specific parts
> for those that are capable of running under old IDE are not too hard to
> plug into libata.

The contrary is also true, for modern drivers/ide conversion of libata PATA
driver to use drivers/ide should usually be a matter of an hour or two.

I think that the conversion of libata drivers for PATA hardware that is not
supported by drivers/ide currently should be doable by somebody knowing
both subsystems in less than 24h.  I'm not doing it only because it will make
me a maintainer of even more host drivers than currently and I don't have a
time for it.  I'll happily accept patches though.

Thanks,
Bart
