Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732Ab0ALT2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab0ALT2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 14:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476Ab0ALT2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 14:28:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:13064 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab0ALT2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 14:28:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=xNStqVOLNLIajH9DdWTQ3XEcLtCsucoHtTQ213ZJ2F9tQA83OkyVJ15sMS1dZVJBwC
         yg8Wd3Dipv/OkWYrsqXWOAaXxtiHxSmyLv3hsYO8uxRsv0AEu/gelQreymDKkAX3np7b
         gpWtpAN3TQY/1kNrwKTWt+lnUlzsOVaqOoc2s=
Subject: RFC: [PATCH V3 0/9 Integration of SmartMedia/xD into mtd subsystem
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>, joern <joern@logfs.org>,
       Alex Dubov <oakad@yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jan 2010 21:28:38 +0200
Message-ID: <1263324518.6236.18.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is third version of my patches.

Changes since V2:

* Resolved write speed problem, now write speed is around 1 MB/s
more that twice the speed of windows driver.

* Made the FTL less dependent on mtd driver.
It now uses standard mtd functions for bad block handling.
Also made initial device scan be safer against damaged media.

* FTL doesn't depend on common module any more.
This makes Kconfig much cleaner, and makes it possible to use the FTl
without enabling the nand support.
Common module is cleaned up a lot.

Now, everything works, everything is fast (except maybe initial zone
scan which takes around 2 seconds...)

Still bear in mind that FTL can destroy data, especially if your flash
card is worn out.

I consider this version to be merge worthy.

Best regards,
Maxim Levitsky

