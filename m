Return-Path: <linux-kernel-owner+w=401wt.eu-S965577AbXA0AnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965577AbXA0AnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 19:43:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965007AbXA0AnC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 19:43:02 -0500
Received: from smtp102.sbc.mail.mud.yahoo.com ([68.142.198.201]:23617 "HELO
	smtp102.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752158AbXA0AnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 19:43:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=MpQjAuLL1AaIo1ahojZTUmhlySqH1Z40y28er8l1B5OHUsCSBmvAfkWGQMwP+aqQuxAPaK2HF1pIwBeSkzu5TsX6OTMb+cMeoJlQJiGmo0tRC/HQA9NDEaRCLPSFqzfXsgkpJxfjQ2weoeFbgfATQhM59xVKK4hoWteVicZGvpc=  ;
X-YMail-OSG: dKFYqCkVM1n0_eX9A5_Qov.0GYm1vpTVXc6rFVxzu5L8sknnOq0abkVywmz.y9ZhNgYJAALsIQQ4kLS0oakOv.uCl6sHdmRAj4oKp4sEIv328TXroETpfwMDVaWLeO54pspwS5xdVO6quAxSPaQQURK2ZcYD6fuh
From: David Brownell <david-b@pacbell.net>
To: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
Subject: Re: 5 patches: updates to SPI and mmc_spi, kernel 2.6.19
Date: Fri, 26 Jan 2007 15:23:08 -0800
User-Agent: KMail/1.7.1
Cc: linux-kernel@vger.kernel.org, mikael.starvik@axis.com,
       spi-devel-general@lists.sourceforge.net
References: <200701261431.l0QEVnbL003112@ignucius.se.axis.com>
In-Reply-To: <200701261431.l0QEVnbL003112@ignucius.se.axis.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701261523.08488.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 January 2007 6:31 am, Hans-Peter Nilsson wrote:
> > From: David Brownell <david-b@pacbell.net>
> > Date: Thu, 25 Jan 2007 04:59:37 -0800
> 
> > So to summarize ... you now have MMC-over-SPI working on CRIS
> > hardware, with these patches?
> 
> Yes.  FWIW, we'll ship with our ETRAX FS developer boards, soon
> enough (in a week or so, knock-on-wood).

Cool!  It's getting more real then.


> >   Can you yet run filesystem
> > stress tests with ext3 on such an MMC card,
> 
> I'd have to configure it in, but I guess I could, if you're not
> happy with just vfat.  I just copied (tarred both to file, and
> separately copied the tree through tar) 174 MeB from a USB stick
> to separately a 512 MeB SDcard and a 2 GiB MMC card and they
> both read out correctly from an (USB) SDcard reader connected to
> my PC.  Is there a specific test you have in mind?

No, I just wanted to get a feel for how solid you thought this was.

- Dave

