Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbYIDPRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbYIDPRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 11:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYIDPRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 11:17:30 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:45308 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbYIDPR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 11:17:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JS6uUE/oMRYmPPY0JOa0l5O9JSmdr0hdvF0WmoUSshuvuxDXuHRj0w7yKcMfHBHLvg
         7Y7mX50PaemHGfjmvcR2+AGzHp6zQ3xoHGE9JbYbZHUGf7Fk59Pj2L8nPQJWJCUJeMMW
         ZvrjzoUU6a9brwX8OdnSBKoCjgS4G0iVHIQOk=
Message-ID: <82ecf08e0809040817l73b1bb9dn8d01212708feadd4@mail.gmail.com>
Date: Thu, 4 Sep 2008 12:17:27 -0300
From: "Thiago Galesi" <thiagogalesi@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix - device 152d:2338
Cc: "Alex Buell" <alex.buell@munted.org.uk>, linux-kernel@vger.kernel.org,
       "Robert Hancock" <hancockr@shaw.ca>, "Tomas Styblo" <tripie@cpan.org>,
       linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
In-Reply-To: <Pine.LNX.4.44L0.0809040958370.2474-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82ecf08e0809040509v323a3065h68a2e72dc86f23ac@mail.gmail.com>
	 <Pine.LNX.4.44L0.0809040958370.2474-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Who would ever design a device that was supposed to stop working when
> it received an unknown command?  Obviously there's a bug either in the
> device or in the JMicron adapter.

I agree :)

> What commands does cdrecord send and where does it fail?
>

If I remember correctly it was a problem during the actual recording.
I'll redo that, but it will probably mean another coaster in my desk ;)

> Oh yes, one other thing...  Have you tried hooking this drive directly
> to an IDE cable (avoiding the USB-ATA adapter) to see if it works okay
> in that environment?  If it does then you know where the bug is.

I'll try that. My bet is on the USB converter, since reloading the
entire usb modules chain makes it work again
Problem is I'm not using this drive as an 'external drive', rather,
the jmicron device is in the motherboard, providing a 'native IDE
port' in the MB (I know, I know)

Needless to say this works flawlessly in that other proprietary OS...

-- 
-
Thiago Galesi
