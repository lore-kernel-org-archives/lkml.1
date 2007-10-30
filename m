Return-Path: <linux-kernel-owner+w=401wt.eu-S1759013AbXJ3Ura@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759013AbXJ3Ura (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbXJ3UrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:47:22 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:37856 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbXJ3UrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:47:22 -0400
Date: Tue, 30 Oct 2007 21:47:20 +0100
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: Huawei E220 and usb storage
Message-ID: <20071030204720.GI8479@gamma.logic.tuwien.ac.at>
References: <20071030190945.GC32153@gamma.logic.tuwien.ac.at> <20071030211729.6a80a93a.Kristoffer.ericson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030211729.6a80a93a.Kristoffer.ericson@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kristoffer,

thanks for the feedback.

On Di, 30 Okt 2007, Kristoffer Ericson wrote:
> Im using a Huawei E220 USB modem, currently running 2.6.22.5 vanilla kernel. It has worked fine for me since 2.6.21.

Strange. I rebuilt the kernel, compiled the usb serial and options into
the kernel, while leaving usb-storage as module. Still I have to issue
the huaweiAktBbo program to get it working/switching into the *right*
modus.

> The lights give you a hint what mode its in. Green = usb_storage, Dark-blue = MODEM_slow, bright-blue = MODEM_fast (3G).

BTW, I have seen a slightly different pattern: Green blinking from the
beginning
calling huaweiAktBbo to make the switch
still blinking green
calling the internet provider
when the connection is established (on the hardware level, not on ip
level) the modem starts blinking blue and then solid blue
turning off the ppp connection it goes into blinking blue mode

> If the light is green after reboot, I need to reboot again until it turns blue. I know this sucks, but just something I've noticed.

Probably you could use the huaweiAktBbo program for this, too.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
HASELBURY PLUCKNETT (n.)
A mechanical device for cleaning combs invented during the industrial
revolution at the same time as Arkwright's Spinning Jenny, but which
didn't catch on in the same way.
			--- Douglas Adams, The Meaning of Liff
