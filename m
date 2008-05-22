Return-Path: <linux-kernel-owner+w=401wt.eu-S1763205AbYEVLOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763205AbYEVLOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 07:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbYEVLOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 07:14:05 -0400
Received: from mail.scaimas.com ([195.82.67.50]:19223 "EHLO mail.scaimas.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169AbYEVLOE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 07:14:04 -0400
X-Greylist: delayed 792 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 May 2008 07:14:04 EDT
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: Limit SATA link speed to 1.5 Gbps 
Date: Thu, 22 May 2008 13:00:50 +0200
X-MimeOLE: Produced By Microsoft Exchange V6.0.6619.12
Message-ID: <F7D77F204D5F7641AB3864C88E39498F18614E@taube3.scailokal.intern>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Limit SATA link speed to 1.5 Gbps 
Thread-Index: Aci7+xlYI8biyLzoRha3j8mmpXNxTA==
From: "Andre Pietsch" <andre.pietsch@scai.de>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I hope this is not OT or not allowed to post here as there might be better places elsewhere. I STW and read the FAQ but did not find something that forbids it.

I own a DELL Vostro 1700 with
ICH8
2 x ST980813ASG, 80GB SATA drive.

Many times the disk produces ATA bus errors and "hard resetting link" appear in the log. While this happens the system hangs (Ubuntu 8.0.4).

In the past it resetted the link 3.0 Gbps and a few minutes later ATA bus errors and "hard resetting link" appear again.

I tested 2.6.25 and the error still occurrs once but then it gave me a "limiting SATA link speed to 1.5 Gbps" in the log.

After that the error does not show again for this boot.

Going back to 2.6.24 it shows the same behaviour now (very odd, since SATA control seems to be kernel specific to me).

All good one could think, but
1) I need to reinstall, since I would like to install 64Bit Ubuntu (currently 32Bit) and
2) I do not know if I can reproduce that "fix".

Is it possible to set the SATA link speed somewhere?

For a dmesg log see here
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/196076/comments/20

This bug report was opened when I thought this was a drive specific NCQ issue...

I still do not what the cause is but having the interface running at 1.5 Gbps stable would be sufficient for me.

Regards,
Andre Pietsch, SCAI GmbH 
