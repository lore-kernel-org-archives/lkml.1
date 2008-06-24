Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbYFXFHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbYFXFHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 01:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbYFXFHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 01:07:22 -0400
Received: from sachiko.kuiki.net ([80.68.89.100]:3579 "EHLO sachiko.kuiki.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbYFXFHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 01:07:21 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jun 2008 01:07:21 EDT
Date: Mon, 23 Jun 2008 21:59:55 -0700
From: Jonathan Steinert <hachi@kuiki.net>
To: linux-kernel@vger.kernel.org
Subject: USB attached SATA disk idle spindown
Message-ID: <20080624045953.GA24600@miyako.sixapart.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear list,

I am looking for what the current state of USB SATA timed spindown of-
disks is ata this time. I've been reading documents and mailing lists-
for every possible search I can dream up on the subject. Suggested-
workable solutions include (but are probably not limited to):

$ hdparm -S
    This seems to be the ATA way of telling a disk to spin down, and it
    works in some situations, but doesn't appear to work on USB attached
    disks under 2.6.25

$ sdparm
    This is suggested in a small number of locations. Most of which have
    examples on how to disable STANDBY on a handful of devices. I am
    unable to find any evidence that it can actually be used to enable
    power saving.

$ scsi_spin
    Requires the disk to be unmounted, and I can't find anything saying
    that this is how the world is supposed to be.-

I'm hoping that perhaps I'm missing something from this list.

I don't really know whether this is a topic for the scsi people, or the-
SATA people, or the USB people. So I'm asking here instead to try and
get my first hints from the parent group.

Thanks in advance,

hachi

------------------------------------------------------------------------
"She smiled again, shrugged her shoulders, and became a perfect mirror."
------------------------------------------------------------------------
