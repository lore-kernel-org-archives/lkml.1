Return-Path: <linux-kernel-owner+w=401wt.eu-S1757205AbXFOQ0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbXFOQ0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbXFOQZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:25:54 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:8527 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbXFOQZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:25:53 -0400
Date: Fri, 15 Jun 2007 18:25:52 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Christian Schmidt <lkml@digadd.de>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Help needed: Partitioned software raid > 2TB
In-Reply-To: <46729C14.5000809@digadd.de>
Message-ID: <Pine.LNX.4.64.0706151824240.32724@fbirervta.pbzchgretzou.qr>
References: <46727E7C.8060102@digadd.de> <p73d4zxs2q4.fsf@bingen.suse.de>
 <46729C14.5000809@digadd.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 15 2007 16:03, Christian Schmidt wrote:
>Hi Andi,
>
>Andi Kleen wrote:
>> Christian Schmidt <lkml@digadd.de> writes:
>>> Where is the inherent limit? The partitioning software, or partitioning
>>> all by itself?
>> 
>> DOS style partitioning don't support more than 2TB. You either need
>> to use EFI partitions (e.g. using parted) or LVM. Since parted's
>> user interface is not good for much more than serving
>> as a bad example I would recommend LVM.

parted's interface is no worse than that of [sfc]disk. Anyway...

>Thanks for the clarification. I didn't use LVM on the device on purpose,
>as root on LVM requires initrd (which I strongly dislike as
>yet-another-point-of-failure). As LVM is on the large partition anyway
>I'll just add the second partition for now, and change the system setup
>with the next drive migration. Maybe linux even supports root-on-lvm
>natively until then ;)

Uh, it does. By means of initrd/ramfs image. Blame your distro if it still
can't do root-on-LVM, there is at least one who can.


	Jan
-- 
