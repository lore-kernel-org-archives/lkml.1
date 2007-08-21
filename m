Return-Path: <linux-kernel-owner+w=401wt.eu-S932183AbXHUSg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbXHUSg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 14:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760509AbXHUSgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 14:36:47 -0400
Received: from smtp108.sbc.mail.re2.yahoo.com ([68.142.229.97]:35497 "HELO
	smtp108.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757191AbXHUSgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 14:36:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JcNqHb8o4zCn0POQ7/JHZWpgzftB39BMcxaF/8giB24ewDLDfQx2vYbBSD9XgNLEI6x0U/SsDy8B4wbhOqNB2XK1zBR8efVIEOvPpCz9+nmSE8tG6oNy1XbkQ7RKJbpkiQRsKwyOo78cbBIIr2XkGUtFItJsKeArpgwRvIF7sjM=  ;
X-YMail-OSG: Y1fRhH4VM1k3fCIah2ZoZw016crS3s7SFJxxfAdWBA_fWsxTfdPn_GHwrUe_oAA6J9muoWHjvAF1rEVQHt6smIur.EggZ_WK3UxeHbMCkK_FcN0qjR2iauniHwufvaePp9kNA73GOEAg8w0-
From: David Brownell <david-b@pacbell.net>
To: Tony Jones <tonyj@suse.de>
Subject: Re: [patch 09/14] Convert from class_device to device for SPI
Date: Tue, 21 Aug 2007 11:28:28 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
References: <20070820224806.154198000@suse.de> <20070820225122.627806000@suse.de> <20070821150119.GH26519@suse.de>
In-Reply-To: <20070821150119.GH26519@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708211128.28552.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 August 2007, Tony Jones wrote:
> On Mon, Aug 20, 2007 at 03:48:15PM -0700, tonyj@suse.de wrote:
> > 
> > Convert from class_device to device for drivers/spi.  This is part of the work 
> > to eliminate struct class_device.
> 
> Signed-off-by: Tony Jones <tonyj@suse.de>

Yeah, "no signoff" was one of my first reactions to that.  :)


Can you update the Documentation/spi/spi-summary text which is
invalidated by this change?  That's part of why I rejected an
earlier version of this patch:  since it broke the documentation,
it was incomplete.

The other reason was to explore removing the "struct class" too,
since it's not necessary.  But it turns out to be simpler to
keep it in there to allocate the bus IDs.  So I've changed my
mind, and will merge a patch like $SUBJECT if it's complete
(i.e. doesn't leave broken/invalid docs).

- Dave

