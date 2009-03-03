Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbZCCHPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbZCCHPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 02:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbZCCHO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 02:14:59 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:12734 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbZCCHO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 02:14:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ehx+6DOupHDDYjv5WWbvCH7nUU8ViQCH1dJXvogxTODAuQpC5wMZPhMywgnCFqxtHP
         Qj91mVCvRQd/w90ZcCYVGrnQqgz9al7DWtGznNrfWXijh35D94cLTkOsms7dK2tMhaWU
         5oNGDpu+zXLcqX7anqH52gp3BstB844QeZoTg=
MIME-Version: 1.0
Date: Mon, 2 Mar 2009 23:14:56 -0800
Message-ID: <43e72e890903022314o44ae710u834d6207403fd4a2@mail.gmail.com>
Subject: Staging, place holder for better company/community development model
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jouni Malinen <j@w1.fi>, Sujith <m.sujith@gmail.com>,
       Sujith <Sujith.Manoharan@atheros.com>,
       Senthilkumar Balasubramanian 
	<Senthilkumar.Balasubramanian@atheros.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Christoph Hellwig <hch@infradead.org>,
       Vasanthakumar Thiagarajan <vasanth@atheros.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A lot of people really hate the staging tree. I don't but let me tell
you why and I'd like to see if you concur with these particular
concrete use cases and ideas on how to further use it.

The ath9k driver came to many as a big surprise -- and since it was a
surprise we had to do the work ourselves as a team at Atheros in
closed doors, without the community's involvement until we got
something standing up and not smelling as bad. Our own change in
direction to work on things upstream can be seen later as well by the
release of the 11n Otus driver and documentation provided to
interested developers to port it to mac80211 (not to mention similar
type of work for ath5k) -- Johannes quickly then ported it and created
the ar9170 11n USB driver which is its replacement for otus and
targeted for wireless-testing. Otus is currently part of the staging
tree. While ar9170 has no 802.11n support users wishing to test 11n
USB with an open driver can use the "vendor" driver. The idea is to
minimize as time goes by the "port" effort and get things out to the
community faster.

With future devices we may want to create a better path for
integration into upstream drivers. But I also want users to get
support for the devices as soon as those devices hit shelves in the
market, maybe even before. So I would like to think of staging not
only as a place for people to put drivers which a company has no
resources to do the right job but also perhaps to _do_ the actual port
work _with_ the community together. By doing so we get devices
supported with whatever ugly piece of code makes the device run (as
long as its open, upstreamble, etc) but we also can engage with the
community on the actual engineering and future of the actual driver we
do want to support in Linux.

As time goes by hopefully staging will not be necessary as companies
(like ours) will have an immediate well defined structure for their
drivers to easily add support for further devices.

If we should take this approach -- should we send patches for wireless
staging to John, or Greg? It would still be "crap" so I don't expect
John to accept to help maintain crap but what if its crap with a clear
defined path to un-crap land?

  Luis
