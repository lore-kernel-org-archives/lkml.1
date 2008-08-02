Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbYHBUJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbYHBUJS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 16:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbYHBUJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 16:09:05 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:47761 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbYHBUJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 16:09:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18580.48861.657366.629904@stoffel.org>
Date: Sat, 2 Aug 2008 16:09:01 -0400
From: "John Stoffel" <john@stoffel.org>
To: linasvepstas@gmail.com
Cc: "Alistair John Strachan" <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: amd64 sata_nv (massive) memory corruption
In-Reply-To: <3ae3aa420808011951l58da4010r1ff0876f255565b0@mail.gmail.com>
References: <3ae3aa420808011030weadc61fvf6f850f0a4cfcb3e@mail.gmail.com>
	<200808012319.05038.alistair@devzero.co.uk>
	<3ae3aa420808011951l58da4010r1ff0876f255565b0@mail.gmail.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Linas" == Linas Vepstas <linasvepstas@gmail.com> writes:

Linas> 2008/8/1 Alistair John Strachan <alistair@devzero.co.uk>:
>> On Friday 01 August 2008 18:30:34 Linas Vepstas wrote:
>>> Hi,
>>> 
>>> I'm seeing strong, easily reproducible (and silent) corruption on a
>>> sata-attached
>>> disk drive on an amd64 board.  It might be the disk itself, but I
>>> doubt it; googling
>>> suggests that its somehow iommu-related but I cannot confirm this.
>> 
>> Nowhere do you explicitly say you have memtest86'ed the RAM.

Linas> It passes memtest86+ just fine. The system has been in heavy
Linas> use doing big science calculations on big datasets (multi-gigabyte)
Linas> for months; these do not get corrupted when copied/moved around
Linas> on the old parallel IDE disk, nor moving/copying on an NFS mount
Linas> to a file server. Only the SATA disk is misbehaving.

Can you post the output of dmesg after a boot, so we can see which
driver is being used?  I assume the new Libata stuff, but maybe you
can also turn on debugging in there as well.  Stuff like SCSI_DEBUG
(in the SCSI menus) might show us more details here.

Also, have you tried a new SATA cable by any chance?  That's obviously
the cheaper path than getting a new disk...

Good luck,
John

