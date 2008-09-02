Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbYIBUQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbYIBUQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 16:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbYIBUQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 16:16:25 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:30181 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbYIBUQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 16:16:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sSSxWUmnLctCeGP+OxaBD7TyVtlGFd4Vq4c3wPEO13Fh7azVO9VHCDbKLlOaEMGosG
         0jpZMw8+ReiPuaWoSEyx9Xw2yjXXRYiu0zgj+lMRdTqm0H55xdfKG3RuXZof+t26uzy4
         wcC5KRaoOvuLTAN7iiZt7ReJaUxtxFQUEbQ7U=
Message-ID: <82ecf08e0809021316l68272103q9daff7b12ed90e8b@mail.gmail.com>
Date: Tue, 2 Sep 2008 17:16:22 -0300
From: "Thiago Galesi" <thiagogalesi@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix - device 152d:2338
Cc: "Alex Buell" <alex.buell@munted.org.uk>, linux-kernel@vger.kernel.org,
       "Robert Hancock" <hancockr@shaw.ca>, "Tomas Styblo" <tripie@cpan.org>,
       linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
In-Reply-To: <Pine.LNX.4.44L0.0809021508480.5583-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82ecf08e0809020907x102179b6ld0d372547759a143@mail.gmail.com>
	 <Pine.LNX.4.44L0.0809021508480.5583-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

>
> I can't tell exactly what's happening, but your device is sending back
> a lot of error messages (Not Ready - Medium not present).  Maybe it
> doesn't recognize the type of disc you have loaded. Also, there appears to be some program querying the state of your
> device 7 or 8 times every two seconds.

Ok, I suspect what this may be, and I'll disable it, hopefully
producing a cleaner log.

> However what finally caused the failure was a command (0xAC) which I
> don't recognize and apparently your drive doesn't recognize either.

Is this it? dfbb5d80 1845367929 C Bi:6:002:1 0 13 = 55534253 acc90100
00000000 00

Any idea who may be sending this? I mean,  can this be send via a
simple IOCTL to /dev/sr0 or it is something else?
Maybe stracing the program would be a good idea.

If I were to place a trace inside a driver, were would it be better?
sr_mod, sd_mod, usb-storage, cdrom? or somewhere else?

Thank you

-- 
-
Thiago Galesi
