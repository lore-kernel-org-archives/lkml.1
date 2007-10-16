Return-Path: <linux-kernel-owner+w=401wt.eu-S1760401AbXJPQUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760401AbXJPQUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 12:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbXJPQUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 12:20:08 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:34460 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227AbXJPQUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 12:20:07 -0400
Date: Wed, 17 Oct 2007 01:20:03 +0900 (JST)
Message-Id: <20071017.012003.99753572.yoshfuji@linux-ipv6.org>
To: jeff@garzik.org
Cc: alan@lxorguk.ukuu.org.uk, cebbert@redhat.com, konstantin.kalin@gmail.com,
       linux-kernel@vger.kernel.org, yoshfuji@linux-ipv6.org
Subject: Re: NVIDIA Ethernet & invalid MAC
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <4714E02D.7040804@garzik.org>
References: <4714D5B8.8020301@redhat.com>
	<20071016164354.6f4e530a@the-village.bc.nu>
	<4714E02D.7040804@garzik.org>
Organization: USAGI/WIDE Project
X-URL: http://www.yoshifuji.org/%7Ehideaki/
X-Fingerprint: 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
X-PGP-Key-URL: http://www.yoshifuji.org/%7Ehideaki/hideaki@yoshifuji.org.asc
X-Face: "5$Al-.M>NJ%a'@hhZdQm:."qn~PA^gq4o*>iCFToq*bAi#4FRtx}enhuQKz7fNqQz\BYU]
 $~O_5m-9'}MIs`XGwIEscw;e5b>n"B_?j/AkL~i/MEa<!5P`&C$@oP>ZBLP
X-Mailer: Mew version 3.3 on Emacs 20.7 / Mule 4.1 (AOI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <4714E02D.7040804@garzik.org> (at Tue, 16 Oct 2007 12:00:45 -0400), Jeff Garzik <jeff@garzik.org> says:

> Alan Cox wrote:
> >> See the below for another report of this:
> >>
> >> http://marc.info/?t=119215716900001&r=1&w=2
> >>
> >> And apparently some motherboard vendors have their own allocations for ethernet
> >> addresses?
> > 
> > We can teach it two ranges. I doubt anyone will be unlucky enough to have
> > the one which could be either Nvidia or Gigabyte and have it matter.
> > 
> > The "go complain to the BIOS vendor" comment from Nvidia to me isn't an
> > answer. Maybe Nvidia can complain to BIOS vendors but end user complaints
> > of that form rarely have any effect.
> 
> That wasn't the point of the response at all.  The datum is that set of 
> users where DEV_HAS_CORRECT_MACADDR is accurately set or clear is vast 
> majority of cases.
> 
> For the rest, we'll want to look at adjusting DEV_HAS_CORRECT_MACADDR 
> based on DMI strings or a hueristic like you suggested.

I think we could have kernel parameter as well.

--yoshfuji
