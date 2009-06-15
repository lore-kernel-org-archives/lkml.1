Return-Path: <linux-kernel-owner+w=401wt.eu-S935876AbZFOV5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935876AbZFOV5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 17:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbZFOV5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 17:57:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39978 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752720AbZFOV5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 17:57:17 -0400
Date: Mon, 15 Jun 2009 22:58:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Cc: linux-parport@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] parport_pc: after superio probing restore original
 register values
Message-ID: <20090615225826.63c26c18@lxorguk.ukuu.org.uk>
In-Reply-To: <4A368600.5030009@LiPPERTEmbedded.de>
References: <4A368600.5030009@LiPPERTEmbedded.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009 19:33:52 +0200
Jens Rottmann <JRottmann@LiPPERTEmbedded.de> wrote:

> CONFIG_PARPORT_PC_SUPERIO probes for various superio chips by writing
> byte sequences to a set of different potential I/O ranges.  But the
> probed ranges are not exclusive to parallel ports.  Some of our boards
> just happen to have a watchdog in one of them.  Took us almost a week
> to figure out why some distros reboot without warning after running
> flawlessly for 3 hours.  For exactly 170 = 0xAA minutes, that is ...

Ouch - that must have been a pig to find.

> Fixed by restoring original values after probing.  Also fixed too small
> request_region() in detect_and_report_it87().
> 
> Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>

Will queue for Linus

Alan
