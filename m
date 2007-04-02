Return-Path: <linux-kernel-owner+w=401wt.eu-S1751924AbXDBICR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbXDBICR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 04:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbXDBICQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 04:02:16 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:38549 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbXDBICO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 04:02:14 -0400
Date: Mon, 2 Apr 2007 10:01:52 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Antonino A. Daplas" <adaplas@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/16] vt-pure-colors.diff
In-Reply-To: <1175500241.4614.23.camel@daplas>
Message-ID: <Pine.LNX.4.61.0704020952530.29350@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr> 
 <Pine.LNX.4.61.0704012002330.12316@yvahk01.tjqt.qr>  <1175496592.4614.9.camel@daplas>
  <Pine.LNX.4.61.0704020902200.1245@yvahk01.tjqt.qr> <1175500241.4614.23.camel@daplas>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 2 2007 15:50, Antonino A. Daplas wrote:
>On Mon, 2007-04-02 at 09:04 +0200, Jan Engelhardt wrote:
>> On Apr 2 2007 14:49, Antonino A. Daplas wrote:
>> >
>> >Not too sure about this, the default palette is based on ANSI/ECMA
>> >standards (at least for the first 8 colors). Also, this will have subtle
>> >effects on the 16-color logo. Since your first patch already allows us
>> >to change the palette, let's leave the default alone.
>> 
>> Ok.
>> But to note: xterm and anything graphical (including MS Windows)
>> uses the anti-pale color (255,0,0) instead of (255,170,170).
>
>Actually, what threw me off was index 4 in default_blu, which has a
>value of 0x90.  This looks weird to me, but I guess that is a typo. I
>really have nothing against using 0, 0, 255 instead of 170, 170, 255 in
>the intense version of the first 8.

That one is a psychological thing. :-) People like blue backgrounds, because a
green or red one would not really fit as a bg color for Midnight Commander,
pine and your-favorite-editor. So you choose blue because it fits nicely. (See
http://img81.imageshack.us/img81/8858/blueqj6.png for an example, and compare
with http://img81.imageshack.us/img81/7498/reddm1.png and
http://img142.imageshack.us/img142/8470/greennq2.png for counterexamples. Even
a bright blue (0,0,192) is still better than red/green, the reason being that
blue is much less percepted by the eye than green or red. You will find various
formulas on the 'net that will convert from color to grayscale - these formulas
have the 'perception' levels, which are, summarized, 76*r, 151*g, 26*b on a 255
scale.) Personally I find the regular blue (0,0,170/0xA0) a little too bright
so I turned it down to 0x90. Adjust for your preference.


Jan
-- 
