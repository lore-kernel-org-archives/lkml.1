Return-Path: <linux-kernel-owner+w=401wt.eu-S1755061AbZGSSTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbZGSSTS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 14:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbZGSSTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 14:19:17 -0400
Received: from rtr.ca ([76.10.145.34]:44877 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754751AbZGSSTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 14:19:17 -0400
Message-ID: <4A6363A4.5020504@rtr.ca>
Date: Sun, 19 Jul 2009 14:19:16 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: Linda Walsh <lkml@tlinx.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: disk Partition label changes and reflecting them in 	/dev/disks-by-label/
References: <4A633542.8030502@tlinx.org> <9b2b86520907190922wb4f809dr5a315155211d6744@mail.gmail.com>
In-Reply-To: <9b2b86520907190922wb4f809dr5a315155211d6744@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
>
> The latest version of udev listens for inotify events on block
> devices.  When a utility writes to the block device (or rather, when
> it closes it after opening it for writing), Udev will synthesize a
> "change" event.  The standard udev rules will re-check the device, and
> update the links under /dev/disk to reflect changes in labels etc.
..

Yes, it seems to catch LABEL changes just fine.

On a related note:
But not UUID changes for some reason (?).
