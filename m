Return-Path: <linux-kernel-owner+w=401wt.eu-S1751570AbZICMss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbZICMss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 08:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbZICMsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 08:48:47 -0400
Received: from mail.gmx.net ([213.165.64.20]:38813 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750718AbZICMsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 08:48:47 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1/aabkCz8DaHeWyeTgS8pM6T1AL1kR+M6yW27MhNd
	6Z6Hu6HrO4fgzl
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Greg KH <greg@kroah.com>
Subject: Re: Staging tree status for the .32 kernel merge
Date: Thu, 3 Sep 2009 14:48:43 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc8-sidux-amd64; KDE/4.3.1; x86_64; ; )
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Kalle Valo <kalle.valo@iki.fi>
References: <20090903041429.GA29875@kroah.com> <1251967786.3336.19.camel@johannes.local>
In-Reply-To: <1251967786.3336.19.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200909031448.46943.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thursday 03 September 2009, Johannes Berg wrote:
> Hi Greg,
[...]
> > 	- at76_usb wireless driver.  Again, no one working on it, it
> > 	  will be dropped in .33.
> 
> There's at76c...something...-usb now, with a situation similar to the
> ar9170/otus one.
[...]

at76c50x-usb, the mac80211 port of at76_usb, has been merged mainline in 
2.6.30, it works well on two at76c503a devices for me. 

Performance and features are comparable (there were WPA patches[1] around, 
CCMP for at76c505 devices only, but due to stability issues with the newer 
firmware, they weren't merged in staging or at76c50x-usb); both drivers 
sport an identical device coverage. The 802.11b chipsets themselves are 
no longer in production, but were rather common (also in handhelds) around 
6-9 years ago. In their current state, at76_usb and at76c50x-usb are 
restricted to WEP64/ 128 or unencrypted networks and work equally well 
(at76c50x-usb without the strange quirks that happen with at76_usb).

AT76C503A specification summary:
http://www.atmel.com/dyn/resources/prod_documents/1949S.PDF

AT76C505 specification summary:
http://www.atmel.com/atmel/acrobat/2364s.pdf

[1]	Original WPA patches:
	https://lists.berlios.de/pipermail/at76c503a-develop/2008-May/000240.html

Regards
	Stefan Lippers-Hollmann
