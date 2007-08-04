Return-Path: <linux-kernel-owner+w=401wt.eu-S1763078AbXHDMQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763078AbXHDMQO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 08:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755876AbXHDMP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 08:15:58 -0400
Received: from webmail.icp-qv1-irony2.iinet.net.au ([203.59.1.107]:56485 "EHLO
	webmail.icp-qv1-irony2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755488AbXHDMP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 08:15:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAAFULtEbLzisi/2dsb2JhbAAN
X-IronPort-AV: i="4.19,220,1183305600"; 
   d="scan'208"; a="175954541:sNHT9887022"
Message-ID: <46B46DFA.7000909@gmail.com>
Date: Sat, 04 Aug 2007 22:15:54 +1000
From: William Pettersson <william.pettersson@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070731)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: vojtech@suse.cz
Subject: Re: ALPS touchpad with new Dell not recognised
References: <46B03A42.3030708@gmail.com>
In-Reply-To: <46B03A42.3030708@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------070001010301080504080203"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070001010301080504080203
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi LKML,
Thanks to Vojtech for some advice, I finally got something happening
with this.  Turns out I had to add support for a new model in alps.c,
the attached file does this successfully for my laptop.  It'd be nice to
have others test it, but I am yet to find anyone else who has this same
laptop, with the same mouse issues I have.

With this patch, I now get a functioning touchpad, including side
scrolling, circle scrolling, corner taps etc.  However, I did have to
ramp the configuration numbers up significantly from my old Thinkpad
with its synaptics touchpad.  Minspeed is now 0.8 and maxspeed is 10. 
Also the VertScrollDelta is 10.  I don't know whether these numbers are
crazy high, or just normal for the Alps though.




--------------070001010301080504080203
Content-Type: text/plain;
 name="alps.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="alps.patch"

LS0tIGRyaXZlcnMvaW5wdXQvbW91c2UvYWxwcy5jLm9sZAkyMDA3LTA3LTMxIDIxOjQyOjM3
LjAwMDAwMDAwMCArMTAwMAorKysgZHJpdmVycy9pbnB1dC9tb3VzZS9hbHBzLmMJMjAwNy0w
OC0wNCAyMTo0NTo0My4wMDAwMDAwMDAgKzEwMDAKQEAgLTUzLDYgKzUzLDcgQEAKIAl7IHsg
MHgyMCwgMHgwMiwgMHgwZSB9LAkweGY4LCAweGY4LCBBTFBTX1BBU1MgfCBBTFBTX0RVQUxQ
T0lOVCB9LCAvKiBYWFggKi8KIAl7IHsgMHgyMiwgMHgwMiwgMHgwYSB9LAkweGY4LCAweGY4
LCBBTFBTX1BBU1MgfCBBTFBTX0RVQUxQT0lOVCB9LAogCXsgeyAweDIyLCAweDAyLCAweDE0
IH0sIDB4ZmYsIDB4ZmYsIEFMUFNfUEFTUyB8IEFMUFNfRFVBTFBPSU5UIH0sIC8qIERlbGwg
TGF0aXR1ZGUgRDYwMCAqLworCXsgeyAweDczLCAweDAyLCAweDUwIH0sIDB4NGYsIDB4NGYs
IEFMUFNfRldfQktfMSB9IC8qIERlbGwgVm9zdHJvIDE0MDAgKi8KIH07CiAKIC8qCg==
--------------070001010301080504080203--
