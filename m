Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbYJAW12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbYJAW12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 18:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbYJAW1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 18:27:21 -0400
Received: from tjworld.net ([67.18.187.6]:44963 "EHLO tjworld.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752907AbYJAW1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 18:27:20 -0400
Subject: Re: Building two (external) modules from the same sources
From: TJ <linux@tjworld.net>
To: Greg KH <greg@kroah.com>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Casual J. Programmer" <casualprogrammer@googlemail.com>
In-Reply-To: <20081001200548.GA30009@kroah.com>
References: <200809290949.35749.arvidjaar@mail.ru>
	 <20081001031907.GA19181@kroah.com> <200810011413.17059.arvidjaar@mail.ru>
	 <20081001200548.GA30009@kroah.com>
Content-Type: text/plain
Organization: TJworld
Date: Wed, 01 Oct 2008 23:27:16 +0100
Message-Id: <1222900036.25554.21.camel@hephaestion>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-01 at 13:05 -0700, Greg KH wrote:
> Hm, I'll look at the code and see if I see anything obvious.
> 
> > If someone could offer (link to) hermes-1/2 programming manual ...
> 
> That would probably help out a lot :)

Unfortunately the changes in the corporate history have always confused
the issue of locating the old documentation.

As I understand it, the chipset(s) were originally developed at Lucent
around 1999-ish. In 2000 the division responsible became a subsidiary
called Agere Systems. In 2002 it was spun-off as a separate business. In
April 2007 it was bought by LSI Corporation, and by the end of 2007 had
lost its separate existence, along with its web-site and the developer
resources it provided.

The Wayback Machine has working links to the product data-sheets and the
original driver packages:

http://web.archive.org/web/20031202185415/www.agere.com/client/wlan.html
http://web.archive.org/web/20060330013615/http://www.agere.com/mobility/wireless_lan_drivers.html

There is another source of confusion - the actual chip-sets used.

Under the name WaveLAN/IEEE there was a pre-802.11b chip-set, as well as
the later WaveLAN Hermes I (1/one) and II (2/two) which are 802.11b
compatible.

The orinoco_cs drivers support the Hermes I chip-set, at least for WEP,
but as I recall, not for WPA/WPA2.

With Andrey's modifications the wlags49 driver supports WPA but not WPA2
- at least not in my tests.

The only technical documentation I can find, and I'm not sure it will be
completely applicable to the 802.11b Hermes chip-sets, is the 1999
Lucent Technologies/Bell Labs Innovations document:

"DRAFT Software Interface Specification for Wireless Connection
Interface for WaveLAN/IEEE (HCF-light)"

which is available (for now) from a Berkeley graduate student's site:

http://bwrc.eecs.berkeley.edu/People/Grad_Students/jbeutel/wavelan_s0005-11-light.htm

The HCF information might be pretty close to what is used in the HCF by
the Hermes wlags49 MSF.

TJ.

P.S. Andrey: Your mail-provider (mail.ru) is blocking my emails to you.

