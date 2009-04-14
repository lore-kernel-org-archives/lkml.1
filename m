Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbZDNQeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbZDNQeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbZDNQdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:33:53 -0400
Received: from a4.complang.tuwien.ac.at ([128.130.173.65]:48001 "EHLO
	a4.complang.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbZDNQdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:33:53 -0400
Subject: Re: Out-of-order writing by disk drives
To: andi@firstfloor.org (Andi Kleen)
Date: Tue, 14 Apr 2009 18:33:50 +0200 (CEST)
From: "Anton Ertl" <anton@mips.complang.tuwien.ac.at>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <87r5zv72cl.fsf@basil.nowhere.org>
Reply-To: anton@mips.complang.tuwien.ac.at
X-Info: DVR-Nummer der TU Wien: 0005886
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Ltla2-0000bS-5j@a4.complang.tuwien.ac.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> "Anton Ertl" <anton@mips.complang.tuwien.ac.at> writes:
> >
> > /dev/md2        /home           ext3    defaults,barrier=1      1	2
> 
> Just make sure /dev/md2 is a RAID1, MD RAID0/5/10 don't support barriers.

Thank you.  I added the following to the README:

|Note that, as of this writing (2009-04), not all Linux devices support
|barriers, in particular md devices only support them in RAID 1 mode;
|the kernel will reportedly warn about the lack of barriers if you try
|to use ext3 with barriers on a device that does not support barriers
|(look in, e.g., dmesg).

> See also my general treatise of multiple device barriers earlier today.

I guess you mean <878wm3903h.fsf@basil.nowhere.org> in the
"dm-multipath and write request ordering" thread.  Thank you for the
pointer.

- anton

