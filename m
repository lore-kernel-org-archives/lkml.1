Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbYJTIhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbYJTIhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 04:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbYJTIhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 04:37:05 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:42627 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751190AbYJTIhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 04:37:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JmfsVPNL3q1WcaRo4HP+r7vpFSB4NnWzknEfaz7C9KN9OuTGf3VGQdfUm5b4GERTqQnHLmMG2+XBzBbweYV8EfVDqcXOvvBNDi1G0yToXjLg7L+XvGgkEg6BzX2HY5grUJnKxyvnN3F2gRMRcROtqC4Qq0kIjxSECFsaTu5ggmQ=  ;
X-YMail-OSG: dXZAHmkVM1k1D5jjtqeQ23JxfdgBsPQolII49bl37.sjSYPDF5eZBvFN.gklQUZmx1IMtTPA678BMaYfcCjsui296FZDcnUGCqkzzYCGItskK6QrluR8xmlGWv1oDIyz9QP1tVb0DlkEShrNgPQv7XoD
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Dooks <ben-linux@fluff.org>
Subject: Re: [spi-devel-general] [patch 2.6.27-git] spi_gpio driver
Date: Mon, 20 Oct 2008 01:37:00 -0700
User-Agent: KMail/1.9.10
Cc: Magnus Damm <magnus.damm@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       spi-devel-general@lists.sourceforge.net,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <200807202146.12759.mb@bu3sch.de> <200810192124.36402.david-b@pacbell.net> <20081020091127.GA4413@trinity.fluff.org>
In-Reply-To: <20081020091127.GA4413@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810200137.00875.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 October 2008, Ben Dooks wrote:
> On Sun, Oct 19, 2008 at 09:24:36PM -0700, David Brownell wrote:
> > From: David Brownell <dbrownell@users.sourceforge.net>
> > 
> > Generalize the old at91rm9200 "bootstrap" bitbanging SPI master driver
> > as "spi_gpio", so it works with arbitrary GPIOs and can be configured
> > through platform_data.  Such SPI masters support:
> > 
> >  - any number of bus instances (bus_num is the platform_device.id)
> >  - any number of chipselects (one GPIO per spi_device)
> >  - all four SPI_MODE values, and SPI_CS_HIGH
> >  - i/o word sizes from 1 to 32 bits;
> >  - devices configured as with any other spi_master controller
> 
> Probably worth looking at removing the s3c24xx gpio specific driver and
> replacing it with this.

Good point.  Let me know if you see any issues doing that,
beyond the need to change some boards' setup code and
defconfigs first.

- Dave


