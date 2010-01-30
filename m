Return-Path: <linux-kernel-owner+w=401wt.eu-S1752533Ab0A3PDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab0A3PDO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 10:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329Ab0A3PDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 10:03:08 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:55839 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab0A3PDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 10:03:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=oap/mnVU3rJArdb8ijEhJE3Yym741QyOtXyDCTZ3sgNsosXjZxR4VblffsjCMuIvGf
         G0N3tDQyocNzsLmbXdTX6G3iew2rs45B/mdQvFo6DCVT96u6sU3KXzKYf6gzey6j77g1
         cmMNUFahXX1mZz24DdWJDIpII4BPQgu4TmnLk=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH V5] Work to enable SmartMedia/xD support
Date: Sat, 30 Jan 2010 17:02:31 +0200
Message-Id: <1264863768-27606-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is another minor revision of my work.
In this version I added few (two) sysfs attributes for udev rules

One attribute is exported my mtd driver, and specifies if this is smartmedia or
xd card (its called "media_type")

Another attribute is exported by FTL, and it is extracted vendor name from the card CIS.
I added short common code to translation layer to allow such thing.

Tested this again on 256 byte/page nandsim device, and everything works as usual.
I don't think I will need to change anything major from now on.

Best regards,
	Maxim Levitsky

