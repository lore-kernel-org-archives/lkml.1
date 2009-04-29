Return-Path: <linux-kernel-owner+w=401wt.eu-S1757475AbZD2TS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbZD2TS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZD2TSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:18:47 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43336 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752408AbZD2TSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:18:46 -0400
X-Sasl-enc: kfIDVSJD4T/N+5v5h238JxzHedIU+81n5fgPvdqA420h 1241032725
Date: Wed, 29 Apr 2009 16:18:41 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: usbutils 0.81 release
Message-ID: <20090429191841.GA1598@khazad-dum.debian.net>
References: <20090427193532.GA2948@kroah.com> <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com> <20090429180735.GA29812@kroah.com> <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com> <ac3eb2510904291159s14d7d532q33657eb73007fc4b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510904291159s14d7d532q33657eb73007fc4b@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009, Kay Sievers wrote:
> >>> looks like update-usbids.sh was forgotten from EXTRA_DIST in
> >>> Makefile.am so the released tarball doesnt have the script ;(
> 
> > np, i'll send patches for both
> 
> Ah missed that, sorry. Sounds good if you add it to the tarball, but
> please don't add it to "make install", as packages should not ship
> scripts which change the installed package content, unless it's a
> config file.

Debian places it in /var/lib/usbids/ for a good reason.  So does Ubuntu.
Both have working "update-usbids" scripts (might be the one from upstream,
or something different).  They also have the original file in /usr/share, I
don't know if usbutils was changed to check /var first then /usr, or what.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
