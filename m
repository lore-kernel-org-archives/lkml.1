Return-Path: <linux-kernel-owner+w=401wt.eu-S1758026AbZFVPlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbZFVPlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756770AbZFVPlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:41:37 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49001 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515AbZFVPlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:41:37 -0400
Message-ID: <4A3FA645.8020701@garzik.org>
Date: Mon, 22 Jun 2009 11:41:57 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] parport_pc: after superio probing restore original
 register values
References: <20090622154702.17809.58975.stgit@t61.ukuu.org.uk> <20090622155142.17809.75363.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090622155142.17809.75363.stgit@t61.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
> 
> CONFIG_PARPORT_PC_SUPERIO probes for various superio chips by writing
> byte sequences to a set of different potential I/O ranges.  But the
> probed ranges are not exclusive to parallel ports.  Some of our boards
> just happen to have a watchdog in one of them.  Took us almost a week
> to figure out why some distros reboot without warning after running
> flawlessly for 3 hours.  For exactly 170 = 0xAA minutes, that is ...
> 
> Fixed by restoring original values after probing.  Also fixed too small
> request_region() in detect_and_report_it87().
> 
> Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> Cc: <stable@kernel.org>
> ---
> 
>  drivers/parport/parport_pc.c |   31 +++++++++++++++++++++++++------
>  1 files changed, 25 insertions(+), 6 deletions(-)

Acked-by: Jeff Garzik <jgarzik@redhat.com>


