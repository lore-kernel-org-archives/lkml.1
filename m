Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbXFOODR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbXFOODR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 10:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbXFOODE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 10:03:04 -0400
Received: from echo.digadd.de ([195.47.195.234]:44339 "EHLO mx2.digadd.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751050AbXFOODD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 10:03:03 -0400
Message-ID: <46729C14.5000809@digadd.de>
Date: Fri, 15 Jun 2007 16:03:00 +0200
From: Christian Schmidt <lkml@digadd.de>
User-Agent: Thunderbird 2.0.0.0 (X11/20070425)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Help needed: Partitioned software raid > 2TB
References: <46727E7C.8060102@digadd.de> <p73d4zxs2q4.fsf@bingen.suse.de>
In-Reply-To: <p73d4zxs2q4.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

Andi Kleen wrote:
> Christian Schmidt <lkml@digadd.de> writes:
>> Where is the inherent limit? The partitioning software, or partitioning
>> all by itself?
> 
> DOS style partitioning don't support more than 2TB. You either need
> to use EFI partitions (e.g. using parted) or LVM. Since parted's
> user interface is not good for much more than serving
> as a bad example I would recommend LVM.

Thanks for the clarification. I didn't use LVM on the device on purpose,
as root on LVM requires initrd (which I strongly dislike as
yet-another-point-of-failure). As LVM is on the large partition anyway
I'll just add the second partition for now, and change the system setup
with the next drive migration. Maybe linux even supports root-on-lvm
natively until then ;)

Regards,
Christian
