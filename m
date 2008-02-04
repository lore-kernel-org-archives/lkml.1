Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbYBDAuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbYBDAuq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 19:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbYBDAui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 19:50:38 -0500
Received: from mout2.freenet.de ([195.4.92.92]:35838 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950AbYBDAuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 19:50:37 -0500
Message-ID: <47A6615D.9090201@freenet.de>
Date: Mon, 04 Feb 2008 01:50:37 +0100
From: Patrick Ringl <patrick_@freenet.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-usb@vger.kernel.org, linux-storage@vger.kernel.org
Subject: wrong cylinders of kingston usb pendrive [intel 82801DB]
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am suffering from the following (usb-related?) problem:

I have several different mashines - all x86 architecture - just lets 
call them mashineA, mashineB and mashineC.
Anyway, mashineA has a severe problem with a 
Kingston-USB-pendrive(2gig). I simply cant install anything on it - the 
kernel usually moans with problems like "attempt to access beyond end of 
device" - while it does work fine with several noname usb-pendrives of 
the same size.
Now, I just tested that kingston pendrive on mashineB and mashineC - 
where it runs fine .. I can install debian to it (same installation 
media) without any problem or kernel errors.

I compared the output of dmesg and fdisk from mashineA and mashineB and 
C .. and the difference is simple: mashineA always shows 248 cylinders - 
while all the other mashines show 228 cylinders.

So I guess this is the problem and especially the reason why using it on 
mashineA always fails.

mashineA has the following usb chipset:

vendor     = 'Intel Corporation'
device     = '82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB 2.0 EHCI Controller'


Hopefully you have any suggestions.

PS: I am not subscribed so please CC to me.


regards,
Patrick

