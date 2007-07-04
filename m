Return-Path: <linux-kernel-owner+w=401wt.eu-S1758249AbXGDJh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249AbXGDJh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 05:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757299AbXGDJhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 05:37:13 -0400
Received: from [84.243.56.243] ([84.243.56.243]:56420 "EHLO aurora.bayour.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757370AbXGDJhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 05:37:12 -0400
From: Turbo Fredriksson <turbo@bayour.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Forcibly remove broken disk from LV
Organization: Bah!
X-PGP-Fingerprint: B7 92 93 0E 06 94 D6 22  98 1F 0B 5B FE 33 A1 0B
X-PGP-Key-ID: 0x788CD1A9
X-URL: http://www.bayour.com/
Date: Wed, 04 Jul 2007 11:37:08 +0200
Message-ID: <87lkdwa4sb.fsf@pumba.bayour.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a disk that only gives SCSI errors etc which
I want to remove from the VG. But vgreduce only hangs
and so does pvremove...

If I physically remove the disk, the vg/pv/lv etc isn't
accessible so the vgreduce won't work (claims that it
can't find any PV's etc).

So how do I remove the disk?
