Return-Path: <linux-kernel-owner+w=401wt.eu-S1763521AbYARRBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763521AbYARRBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763322AbYARRB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:01:27 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:18991 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763333AbYARRB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:01:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O2NSeG8KUCVUr1jmEqhy5lij7+TIi+/q//DubFc4u2ShNONFsOdIntscedvB5L/y3Ptswvt+ofgMDsBc0qCfQJS2lIYrCThbYYUMcnEufUBr5LEbc1sbvmsfXWSsP9YOqMKvAQwtlezOthb3NAXIVIIwB2gURQtM1eQqDPEqWn0=
Message-ID: <b4292e150801180901wfb55577kc884276622bc869e@mail.gmail.com>
Date: Fri, 18 Jan 2008 15:01:25 -0200
From: "Adolfo R. Brandes" <arbrandes@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: USB HID: Missing keys on Gyration Media Center Universal Remote Control
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0801171420400.15647@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b4292e150712280848h36a5bbf5k76e121168e8bfd12@mail.gmail.com>
	 <Pine.LNX.4.64.0801171420400.15647@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jiri,

Jiri Kosina:
> this is really weird, that the keys do not produce any debugging output at
> all. Do you think you could use usbmon to see what data is coming from
> they keyboard through USB bus?

  For the "TV" key:

f7d32680 3699560314 C Ii:2:006:2 0:8 3 = 064600
f7d32680 3699560330 S Ii:2:006:2 -115:8 5 <
f7d32680 3699640317 C Ii:2:006:2 0:8 3 = 060000
f7d32680 3699640335 S Ii:2:006:2 -115:8 5 <

  For the "POWER" key (again, no trace of a key release line, only key press):

f7d32680 3876362463 C Ii:2:006:2 0:8 2 = 0382
f7d32680 3876362488 S Ii:2:006:2 -115:8 5 <

"SETUP MENU", "LAST", and "INPUT" produce no output on any of the USB
buses (0u, 1u, 2u).

  I'm starting to think that these last 3 keys are broken, or maybe
just not designed to be used as PC keys (the remote is also a learning
universal IR unit, and these keys  work as they should on the TV and
VCR), though the manual mentions no such thing.  Otherwise they might
require some additional Vista-voodoo, seeing as the remote is labeled
"Vista only" (funnily enough, the "Windows" button works just fine in
Linux).  Is this anything like what happened with the special keys on
the Microsoft Natural Keyboard 4000?

> Thanks for great and detailed bugreport,

  With pleasure, although you are the one to be thanked for helping me
out.  I'll be extremely happy if only we can get the power key working
properly; the other keys are a bonus at this point.

Thank you,
Adolfo
