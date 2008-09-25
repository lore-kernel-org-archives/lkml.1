Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbYIYVNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbYIYVNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbYIYVMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:12:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:52662 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbYIYVMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:12:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=oR0FbRBHHSeLdIYMtSvRSk6BvJTVuNQddYSmOWTHkEpTRsFz/rUC+psYKLuVnLwSnL
         y4bnbKcjvhXhPpQjz6j8h3+jaFBL4tV3GFM+kxLSQ6iAWNVWlM+4YpD/dQ1EDujoGAux
         KCWZtym+Ey6PHzdtnR6OE0D1kNYcuYQy4leK4=
Message-ID: <3baf3d760809251412l28423a22lba5b1b57c411c87e@mail.gmail.com>
Date: Thu, 25 Sep 2008 14:12:50 -0700
From: "Singaravelan Nallasellan" <singaravelann@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Acceptable Interrupt Latency in Linux kernel
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What is the tolerable interrupt latency for the Linux interrupt handler?

I need to write a driver which will require to invoke a function from
other driver
to read the hardware register. That function will send a message to
the firmware in the some other hardware.

The firmware will go into a bus to read the register and return the
value. This firmware generates an interrupt of the completion of the
register read.

So the whole process of register read will take time to know the
interrupt source.

Currently I dont have the exact duration to read a single register. I
am also planning to push the register read to work queue and return
with IRQ handled from the ISR without knowing the hardware
status.There is a potential to mis handle the interrupt.

If I know the acceptable interrupt latency, It will simplify the ISR handling.

Thanks
