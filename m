Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960AbZDVQ4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbZDVQ4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 12:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbZDVQzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 12:55:52 -0400
Received: from exprod6og106.obsmtp.com ([64.18.1.191]:43289 "HELO
	exprod6og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751602AbZDVQzv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 12:55:51 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: linux-next: Tree for April 22 [BUG] ep93xx_keypad_open:undefined reference to `clk_set_rate'
Date: Wed, 22 Apr 2009 12:55:28 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090165EF9B@mi8nycmail19.Mi8.com>
In-Reply-To: <20090422084104.GB20105@traven>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: linux-next: Tree for April 22 [BUG] ep93xx_keypad_open:undefined reference to `clk_set_rate'
Thread-Index: AcnDJhV0HKBd9UTUTHOaBZMJKU8axgAQ/DEg
References: <20090422154247.dbffd285.sfr@canb.auug.org.au> <20090422084104.GB20105@traven>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Matthias Kaehlcke" <matthias@kaehlcke.net>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>
Cc: <linux-next@vger.kernel.org>, "LKML" <linux-kernel@vger.kernel.org>,
       <linux-arm-kernel@lists.arm.linux.org.uk>
X-OriginalArrivalTime: 22 Apr 2009 16:55:48.0784 (UTC) FILETIME=[2FCFE300:01C9C36B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 22, 2009 1:41 AM, Matthias Kaehlcke wrote:
> hi,
>
> the driver for the Cirrus Logic EP93xx keypad matrix relies on the
> function clk_set_rate() which (still) isn't defined for ep93xx:
>
> drivers/built-in.o: In function `ep93xx_keypad_open':
> hid-quirks.c:(.text+0x61aa0): undefined reference to `clk_set_rate'

I didn't realize the EP93xx keypad matrix driver made it to linux-next.
Hmm...

For the driver to function it requires a patch to
arch/arm/mach-ep93xx/clock.c that adds the necessary clk resource and
the clk_set_rate support.

I have a patch for this but I am waiting on a response on another
patch that it depends on.  If needed I can modify the patch so that it
will apply now.

Regards,
Hartley
