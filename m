Return-Path: <linux-kernel-owner+w=401wt.eu-S1761352AbYBFIbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761352AbYBFIbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 03:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758751AbYBFIbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 03:31:34 -0500
Received: from [202.21.16.18] ([202.21.16.18]:33778 "EHLO ingenitech.co.nz"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757112AbYBFIbe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 03:31:34 -0500
X-Greylist: delayed 976 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Feb 2008 03:31:33 EST
Content-class: urn:content-classes:message
Subject: RE: [PATCH][v4] ipwireless: driver for 3G PC Card
Date: Wed, 6 Feb 2008 21:14:23 +1300
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-ID: <240750308FA06543BB7A0192AF5829E8D7EC@sbs.ingenitech.co.nz>
In-Reply-To: <Pine.LNX.4.64.0802060110540.30955@jikos.suse.cz>
X-MS-Has-Attach: 
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH][v4] ipwireless: driver for 3G PC Card
Thread-Index: AchoVVyZElo4ziYYQ16DCTKKnrcpbQAQjm4g
References: <20080201153707.GA24859@ds.suse.cz>  <Pine.LNX.4.64.0802051114390.30955@jikos.suse.cz> <1202255212.15090.180.camel@violet> <alpine.LFD.1.00.0802051600330.2967@woody.linux-foundation.org> <Pine.LNX.4.64.0802060110540.30955@jikos.suse.cz>
From: "Ben Martel" <benm@ingenitech.co.nz>
To: "Jiri Kosina" <jkosina@suse.cz>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Marcel Holtmann" <marcel@holtmann.org>, "David Sterba" <dsterba@suse.cz>,
       <linux-kernel@vger.kernel.org>, <stephen@symmetric.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Baa Baa (a Kiwi greeting :) ),

I have to second Jiri on this one. The card is used as a 'WAN'
technology not a 'LAN' technology platform and hence does not really fit
into the 'wireless 802.11<anything>' space. I think that it should be
merged in where it currently sits. 

   ~benm

-----Original Message-----
From: Jiri Kosina [mailto:jkosina@suse.cz] 
Sent: Wednesday, 6 February 2008 1:15 p.m.
To: Linus Torvalds
Cc: Marcel Holtmann; David Sterba; linux-kernel@vger.kernel.org; Ben
Martel; stephen@symmetric.co.nz
Subject: Re: [PATCH][v4] ipwireless: driver for 3G PC Card

On Tue, 5 Feb 2008, Linus Torvalds wrote:

> And especially with wireless, I think the impact for any future
changes 
> are about the wireless infrastructure, not PCMCIA. There's little
reason 
> to believe that we'll ever make any big PCMCIA overhauls exctly
because 
> PCMCIA is so dead. So I'd happily merge it, but I would be even
happier 
> if I got ack's from the wireless people or if it was simply merged
that 
> way too.

Unfortunately the device has quite confusing name (and the driver of 
course follows). It has 'wireless' in its name, but it has literally 
nothing to do with "wireless" networking, as long as 802.11<anything> is

involved.

It is in fact a PCMCIA card, that acts as a GPRS/EDGE/UMTS modem. So its

This has been already discussed, please see 
http://www.ussg.iu.edu/hypermail/linux/kernel/0711.3/2198.html

Thanks,

-- 
Jiri Kosina
SUSE Labs

Internal Virus Database is out-of-date.
Checked by AVG Free Edition. 
Version: 7.5.503 / Virus Database: 269.16.4/1147 - Release Date:
23/11/2007 9:19 a.m.
 
