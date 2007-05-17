Return-Path: <linux-kernel-owner+w=401wt.eu-S1758218AbXEQOjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbXEQOjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 10:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbXEQOjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 10:39:11 -0400
Received: from smtp5.freeserve.com ([193.252.22.128]:29066 "EHLO
	smtp5.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbXEQOjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 10:39:10 -0400
X-Greylist: delayed 1801 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 May 2007 10:39:10 EDT
X-ME-UUID: 20070517140905803.C41921C00084@mwinf3402.me.freeserve.com
Message-ID: <464C61FF.6080606@cjsoftuk.dyndns.org>
Date: Thu, 17 May 2007 15:09:03 +0100
From: Chris Malton <chrism@cjsoftuk.dyndns.org>
Organization: CJSoft UK
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Saitek USB Gamer's Keyboard
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms080602000401010703070602"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms080602000401010703070602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I have been working on this device for a while, and have come up with 
the following:

The protocol is simple:

?? ?? 52 70 ?? ?? ??
??
KC 1 [DOWN]
?? ?? 52 70 ?? ?? ??

KC	Key
48	1
49	2
50	3
51	4
52	5
53	6
54	7
55	8
56	9
57	Mode A
58	Mode B

The ?? bits represent seemingly random numbers that appear through 
/dev/input/event3, which gets created when the keyboard is plugged in.

I'm in the process of creating a userland application that reads from 
/dev/input/event3 and acts accordingly, based on user preferences.

Should it be the job of the kernel to do the command mapping (and 
subsequently create a virtual keyboard), or should it stay as a 
userland-only program?

I would be intrigued to know.

Chris

--------------ms080602000401010703070602
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
--------------ms080602000401010703070602--

