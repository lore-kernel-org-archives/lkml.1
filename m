Return-Path: <linux-kernel-owner+w=401wt.eu-S1760583AbXHYBGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760583AbXHYBGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 21:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750817AbXHYBGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 21:06:33 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:51087 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbXHYBGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 21:06:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HlZ/LP8dlyFPVUHqeRLszLf/Y05R6PPtJydoB9H/1hNIJW6jhpd/JD0y0Wchd2p7yTTdWkF/pGHWkyBU1B3uwUwsONZ+qf1Iv6gy9PAeSouCdZXFP6EbNjo4xHeE6XcUmxR+m75uAoLzFY1XCPKuqC0b1TpBRTsWPdQwLU4QQTY=
Message-ID: <443c85430708241806y4730bb15n9094fed2e51437f3@mail.gmail.com>
Date: Fri, 24 Aug 2007 21:06:31 -0400
From: TheOneKEA <theonekea@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: Possible problems reading a DVD-RAM disc
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46CF6B71.7030001@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.pKJ1f/uGrEIrPt+FdyZwKxvM2Ws@ifi.uio.no>
	 <46CF6B71.7030001@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mr. Hancock,

On 8/24/07, Robert Hancock <hancockr@shaw.ca> wrote:
> TheOneKEA wrote:
> > While doing a long mega-copy from one side of a DVD-RAM disc formatted
> > with the vfat filesystem to an smbfs network share, I got lots and
> > lots of these in the dmesg:
> >
> > Buffer I/O error on device sr0, logical block 4396
> > lost page write due to I/O error on sr0
> > sr 6:0:0:0: [sr0] Result: hostbyte=0x00 driverbyte=0x08
> > sr 6:0:0:0: [sr0] Sense Key : 0x7 [current]
> > sr 6:0:0:0: [sr0] <<vendor>> ASC=0x92 ASCQ=0x0ASC=0x92 ASCQ=0x0
> > end_request: I/O error, dev sr0, sector 17584
> > Buffer I/O error on device sr0, logical block 4396
> > lost page write due to I/O error on sr0
>
> Well, the drive is reporting an error on a write to the disc. It's not
> an error code in the MMC5 standard, though, so presumably it's a
> vendor-specific error code.

Would I be able to find a datasheet explaining the code?

>
> Not sure why it would be writing to the disc though.. Maybe if the disc
> is mounted read-write it is doing last-access-time updates or something?

It's possible - I didn't explicitly specify noatime when mounting the
volume; does the vfat kernel module honor the noatime option?

-- 
SCREW THE ADS! http://adblock.mozdev.org/
