Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbYHDRax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbYHDRax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 13:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbYHDRao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 13:30:44 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:11823 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbYHDRan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 13:30:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=cBz4Q9keyCvqEnHyjfa/CumlyQDWtSPekU7miRlwtWFpmsKd6Am4KHVsL9MGjfBkJ+
         CsSOOTroA1J1lZ1rbEqNNY213g2DUJiliLS0wp2qODx6TmurrfefuxavfmofJFOpwYqw
         VfJKP+uz8nD4w5HoJCCnc8AffV33gO3kyIzZY=
Message-ID: <f6b4565a0808041030v595dcba7s329b00b3e08dd532@mail.gmail.com>
Date: Mon, 4 Aug 2008 13:30:33 -0400
From: "Andrey Turovsky" <turova@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: usb-skeleton driver question
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I hope this is not the wrong place for my question.  If it is, please
let me know where I should go with it.

I am trying to develop a linux USB driver for communication between
two linux-enabled embedded devices (though current development is
being done on an ubuntu machine connected to one device).  Currently,
the device simply send as much ascii data as it can through the USB
connection.  The goal is to maximize throughput on the full speed
connection.  I have gone through the relevant sections of the O'Reilly
book "Linux Device Drivers", but am fairly confused as to how to
actually go about writing the driver.

I am starting with the usb-skeleton driver.  I changed the product and
vendor IDs to match the device and get a friendly dmesg output: "USB
Skeleton device now attached to USBSkel-192".  Unfortunately, I cannot
find too much relevant information as to what to do next.  The part I
need help with is figuring out how to connect to this device and read
from it.  There are no new devices in /dev/ and even if I create one,
I'm not sure how to link the driver to it.

Thanks for any help..

-Andrey
