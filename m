Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945Ab0AEJ2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab0AEJ2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 04:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535Ab0AEJ2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 04:28:19 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:54572 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750888Ab0AEJ2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 04:28:18 -0500
X-Greylist: delayed 1219 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2010 04:28:18 EST
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.3-dev
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: =?utf-8?q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>, awalls@radix.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       danborkmann@googlemail.com
Subject: Re: [linux-pm] [suspend/resume] Re: userspace notification from module
In-reply-to: <201001042043.27037.rjw@sisk.pl>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <201001040045.39517.rjw@sisk.pl> <a522f3c.3bab16d1.4b413b9c.ec43@o2.pl> <201001042043.27037.rjw@sisk.pl>
Comments: In-reply-to "Rafael J. Wysocki" <rjw@sisk.pl>
   message dated "Mon, 04 Jan 2010 20:43:26 +0100."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 05 Jan 2010 10:07:06 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20100105090706.751D233C4B0@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.238.172
X-Scan-Result: No virus found in message 1NS5P5-0004ov-CQ.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1NS5P5-0004ov-CQ 0d2593ad340d6526a409b8cb1fe92688
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


rjw@sisk.pl said:
>> > I don't see a problem with this in principle, although I don't think signals
>> > are very suitable for this particular purpose, because you need two-way
>> > communication between the power manager and the processes it's going to
>> > notify (because it has to wait for the processes to finish their preparations
>> > and to tell it that they are ready). 

Wouldn't there need to be dependecy tracking for the userspace processes? A 
process couldn't signal "done" until it know there's no more work to do, which 
requires all other processes to finish up first.

