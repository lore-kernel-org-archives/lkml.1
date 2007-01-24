Return-Path: <linux-kernel-owner+w=401wt.eu-S1750863AbXAXJoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750863AbXAXJoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 04:44:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbXAXJoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 04:44:06 -0500
Received: from mclmx.mail.saic.com ([149.8.64.10]:44818 "EHLO
	mclmx.mail.saic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbXAXJoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 04:44:05 -0500
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jan 2007 04:44:04 EST
Subject: IO-APIC + timer doesn't work - 2.6.20-rc5 on abit KN9-Ultra bios
	1.6
From: Eamonn Hamilton <EAMONN.HAMILTON@saic.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 24 Jan 2007 09:28:33 +0000
Message-Id: <1169630914.22508.151.camel@ukabzc383.uk.saic.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Content-Transfer-Encoding: 7bit
X-ukabzc383-MailScanner: Found to be clean
X-ukabzc383-MailScanner-From: eamonn.hamilton@saic.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I can't get any kernel up to 2.6.20-rc5 to boot without using noapic on
an ABIT KN9-Ultra with a dual-core Athlon.

I booted with apic=debug as suggested and got the following :

ENABLING IO-APIC IRQs
.. TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
.. MP-BIOS bug: 8254 timer not connected to IO-APIC
... trying to set up timer (IRQ0) through the 8252A ... failed
... trying to set up timer as Virtual Wire IRQ ... failed
... trying to set up timer as ExtINT IRQ ... failed :(

The bios is the latest, although in various posts on the web it would
appear this occurs in older versions also.

What can I do to help resolve this?

Cheers,
Eamonn
-- 
Eamonn Hamilton <eamonn.hamilton@saic.com>


-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

