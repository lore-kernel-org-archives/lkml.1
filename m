Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbZB1OmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbZB1OmW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 09:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbZB1OmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 09:42:14 -0500
Received: from lvf.volatilevoid.net ([78.46.240.248]:38150 "EHLO
	lvf.volatilevoid.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbZB1OmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 09:42:13 -0500
X-Greylist: delayed 898 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Feb 2009 09:42:13 EST
Date: Sat, 28 Feb 2009 15:41:11 +0100
From: Oliver Martin <oliver@volatilevoid.net>
To: linux-kernel@vger.kernel.org
Cc: jgarzik@pobox.com, oliver@volatilevoid.net
Subject: Kernel panic with 2.6.28.x
Message-ID: <20090228154111.31a5ff6b@ors.home>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've had two kernel panics in a row now with 2.6.28.x on my router/file
server box. The first happened yesterday when copying a bunch of stuff
from an md array to an eSATA disk with ntfs-3g. I compiled 2.6.28.7 and
restarted the copy and everything went well, when I went to bed the
system was still up and running. The NTFS file system wasn't even
mounted any more, but the HDD was still plugged in. When I woke up
today, it had panicked again.

The hardware is an old laptop with a Pentium M and an i845 chipset. The
md array I mentioned is a somewhat frightening combination of LVM on MD
(raid5) on 3xUSB + 1xFirewire disks. It normally works well, though.
The eSATA controller is a sil3512-based PCMCIA card, and normally isn't
plugged in.

The eSATA card (and the attached HDD) is the only thing that was
different from the perfectly stable normal configuration when the
panics happened. The part of the backtrace I could see
(http://volatilevoid.net/kernelpanic.jpg) mentioned some scsi
functions; could it be the culprit? Unfortunately, I don't have any
more information about the panic itself, I'll try to set up netconsole
and see if it happens again.


Regards,
Oliver
