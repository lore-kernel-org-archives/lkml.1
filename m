Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbYKVF0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbYKVF0D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 00:26:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbYKVFZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 00:25:52 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:28788 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1749667AbYKVFZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 00:25:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=OX6wNJ3gY86sVnT+B8PknYB4kQwA96kNvrVEC0MZELCLYqfM15zTCI6HqRrmRUGaNoeyXljBwwyPmV4ffTljSLtqqoHZmNt7qAzqM5fQMUTylQoYm4k2qHTADJgq1wbocZLuFYYTuT0tdiw2dltPPqwQKfBlFHlt3Ywsgb23NGo=  ;
X-YMail-OSG: qouem5IVM1meOBB1JfEEomRREkqP36Id3OFJPkRkyhAW1YEsOs3RuBVbDFUKrdnv_E4viYw.mzoukfRaSvcX8BMx6l_pWcGXQ1qJQI3puEksvtkonew83mv6g11pIC8F0Jp65jI5OlpSCxoc06I6iov3pm6W4bRgqskIRrJkaDzrj0bCfohlOOWSmFr4
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: spi-devel-general@lists.sourceforge.net
Subject: Re: [spi-devel-general] [patch 05/14] mfd: PCAP2 driver
Date: Fri, 21 Nov 2008 21:25:48 -0800
User-Agent: KMail/1.9.10
Cc: stefan@datenfreihafen.org, eric.y.miao@gmail.com, sameo@openedhand.com,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Daniel Ribeiro <drwyrm@gmail.com>, linux-kernel@vger.kernel.org
References: <20081121160403.073751031@dodger.lab.datenfreihafen.org> <20081121160521.016544616@dodger.lab.datenfreihafen.org>
In-Reply-To: <20081121160521.016544616@dodger.lab.datenfreihafen.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811212125.49068.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 November 2008, stefan@datenfreihafen.org wrote:
> Since the last submission we are also using the spi subsystem and
> pxa2xx-spi instead of ssp.c directly as before.

I took a quick glance at this and it seemed like it should be
able to build without depending on PXA ... should certainly
not include <mach/ssp.h> or <mach/regs-ssp.h>, and it doesn't
look like it needs PXA-specific stuff like <mach/mfp-pxa27x.h>
either.

It's also worth removing the reverse dependencies ("select X")
from Kconfig; they don't work very well for the things which
those dependencies rely on.

- Dave
