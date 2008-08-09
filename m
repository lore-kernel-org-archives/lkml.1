Return-Path: <linux-kernel-owner+w=401wt.eu-S1762232AbYHICpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762232AbYHICpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 22:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbYHICpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 22:45:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:23584 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbYHICpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 22:45:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding:sender;
        b=TbOB9X3w7TQPtwOTojHv2nj6XB8GXW2cljUhK7MxHMlImxwBjx4MMwifBZFd42CcoP
         5C/aX9EqS4lM/KtmEdh4nPcAK94uQ1jc43Bb7wlNrI61TgSLk/XvXM6BGQmjm/+vLURc
         MtuiQC6cBBcIePxsSGWolAWgSsv7SPdhReLaM=
Date: Sat, 9 Aug 2008 04:45:30 +0200
From: Oliver Martin <oliver.martin@student.tuwien.ac.at>
To: linux-kernel@vger.kernel.org
Subject: Policy re. cellular USB modem mode switch
Message-ID: <20080809044530.193a077a@ors.home>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

trying to get my ZTE MF628 HSDPA modem to work left me wondering if
there is an established policy whether or not to include the "mode
switch" code most cellular USB modems need in the kernel or not.
Currently, the MF628 requires a userspace helper called usb_modeswitch
to be called [1] to change from mass storage mode to serial mode.
After, that it can be used with the usbserial driver or preferably,
after one adds the right vendor and product id, with the option driver.

The only other such device I know is the Huawei E220, which doesn't
require any userspace tools since 2.6.20. The usb_modeswitch website
lists quite a lot of devices as supported, do any other of them
*require* the use of this (or another) userspace tool? If so, is this
considered acceptable?

The main reason I'm asking this is to find out if I should try to put
the mode switch code in the kernel or not. In the meantime, I'll reply
to this message with a patch to add the vendor/product id of the MF628
to the option driver, which I guess is needed in any case.

Regards,
Oliver

[1] http://www.draisberghof.de/usb_modeswitch/
http://www.draisberghof.de/usb_modeswitch/bb/viewtopic.php?t=81
