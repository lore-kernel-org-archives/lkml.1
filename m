Return-Path: <linux-kernel-owner+w=401wt.eu-S936298AbXFHBu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936298AbXFHBu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 21:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765437AbXFHBuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 21:50:12 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:38387 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763802AbXFHBuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 21:50:10 -0400
X-Sasl-enc: gz3cIc+kyz8GRMB7MuL2jHvZzy3hE0yRPvpprX/YMr+A 1181267409
Date: Thu, 7 Jun 2007 22:50:04 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Mark Lord <lkml@rtr.ca>
Cc: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: Bad behaviour after hdparm -M  128
Message-ID: <20070608015004.GA16785@khazad-dum.debian.net>
References: <fa.DWgGSeKzniALToNSyX9W5NibA1w@ifi.uio.no> <4666C4B9.8060408@shaw.ca> <20070606154442.GB13166@khazad-dum.debian.net> <20070606162425.GA3943@atjola.homenet> <20070606164854.GA18984@khazad-dum.debian.net> <20070606175112.GA4659@atjola.homenet> <20070606210337.GA31549@khazad-dum.debian.net> <20070606213617.GA6580@atjola.homenet> <20070606215232.GC31549@khazad-dum.debian.net> <466827FF.1030304@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <466827FF.1030304@rtr.ca>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Jun 2007, Mark Lord wrote:
> Henrique de Moraes Holschuh wrote:
> >On Wed, 06 Jun 2007, Björn Steinbrink wrote:
> >>HDAPS support is available, revision is MB2IA60A.
> >
> >That would usually rule out the possibility of it being the firmware, but 
> >we
> >have different disks, so different firmware.
> >
> >It looks like I will have to try 2.6.22 to know for sure.
> 
> "hdparm -I" should list "Automatic Acoustic Management feature set"
> (near the bottom) for any drive that *does* support the -M feature.

I just tracked it down to hdparm.  Version 6.9 (the one in Debian stable)
doesn't work right with libata.  Version 7.5 (the one in Debian unstable)
works fine.

So, at least in my side, there are *no* kernel bugs.  Maybe this is also the
case for the poster that reported the problem?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
