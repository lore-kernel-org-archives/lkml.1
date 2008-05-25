Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbYEYUIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbYEYUIi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 16:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757573AbYEYUI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 16:08:29 -0400
Received: from smtp-02.datacomm.ch ([212.40.2.27]:49175 "EHLO
	smtp-02.datacomm.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757338AbYEYUI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 16:08:28 -0400
Subject: Re: SB600 AHCI: Hard Disk Corruption
From: Patrick <ragamuffin@datacomm.ch>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080525173825.GA4132@ucw.cz>
References: <1211717435.6038.53.camel@localhost.localdomain>
	 <20080525173825.GA4132@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 25 May 2008 22:08:26 +0200
Message-Id: <1211746106.6188.57.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> iommu problem? Try it with mem=3G.

YES! :-) How did you know?

Even mem=4G did the trick. I should have tried that out long time back
(!), since it also used to make the fglrx driver problems I was dealing
with go away. These are solved now though, by a recent bios update
(Version 1705 2008/04/21). ﻿The fglrx driver used to work once but
stopped to work after an upgrade one day. Now with the new bios, the
current 
(ubuntu 8.04) version is working.

So now, using mem=4G, ﻿after successfully suspending once, my
ahci-scsi-libata-[sda] disk is still working. The error messages I
mentioned dissapeared from the kernel messages. Some other, usb driver
error messages, that used show up after resume have disappeared as well.

Anyway: using mem=4G is definitely no option! I get only 3G of usable
memory!!! *

So how are we going to get this fixed???

Should the IOMMU be reinitialized after resume? Or should the bios do it
but doesn't? ** On the m2a-vm, the "GART" seems to be used as iommu,
so... :-) ???

I put some kernel message logs here:
http://zefir.freesitespace.net/dmesg/
One log without mem=4G will also be there shortly, where you will see
the messages concerning the iommu (which seems to be unused right now).

Greets
﻿
*
> ﻿I suspect all you need is to burn one dimm.. or send it to me so that
> I can reproduce it ;-).
﻿;-) ...looking back - all the trouble the 4G caused me till now, I
would have saved lots of time mounting only one 2G dimm in the first
place, even if the system was a little slower, but be it...

> ﻿﻿Boot it from cd ;-).
I'm impatient...
﻿
﻿** Seems, the SB600 is not to blame - alas sorry for the subject.

