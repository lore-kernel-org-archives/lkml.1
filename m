Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbYIBQIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbYIBQIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 12:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYIBQIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 12:08:00 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:55038 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbYIBQH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 12:07:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GuL8GXyGosBO9pmF6mXfVlEufsM3zxzayG/JFZma7DouEXhnzuGZVIHRSytTyq5Gzu
         omFMYPpRGySJmC2ihxLXHOW+q9PYBqpcOc96lXhZgD4M+N4ryOsbXj+MgdzYK3+ynpsm
         g+tjVZKRkwZL60d3AxjqxfT4CzV7cAsa6SscA=
Message-ID: <82ecf08e0809020907x102179b6ld0d372547759a143@mail.gmail.com>
Date: Tue, 2 Sep 2008 13:07:57 -0300
From: "Thiago Galesi" <thiagogalesi@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix - device 152d:2338
Cc: "Alex Buell" <alex.buell@munted.org.uk>, linux-kernel@vger.kernel.org,
       "Robert Hancock" <hancockr@shaw.ca>, "Tomas Styblo" <tripie@cpan.org>,
       linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
In-Reply-To: <Pine.LNX.4.44L0.0809021101320.2137-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82ecf08e0809020510s2b752d18i6a1901e87effc07a@mail.gmail.com>
	 <Pine.LNX.4.44L0.0809021101320.2137-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> If nothing works, you should try usbmon (see
> Documentation/usb/usbmon.txt).
>
> Alan Stern

Ok, I've created a USBMON log, here it is here:
http://duskblue.org/jmicron_log_k3b.log

(I guess it is a little too big - 70k -  to be placed in the message directly)

Using k3b, since it seems it is the program which causes more errors.
DVD is completely unusable after I did this, dmesg has sr 4:0:0:0:
rejecting I/O to offline device

If I reload the drivers manually I have the reader back without
rebooting the machine.

-- 
-
Thiago Galesi
