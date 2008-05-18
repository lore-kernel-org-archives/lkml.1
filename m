Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbYERRfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbYERRfb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 13:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbYERRfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 13:35:22 -0400
Received: from eazy.amigager.de ([213.239.192.238]:44956 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbYERRfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 13:35:21 -0400
Date: Sun, 18 May 2008 19:35:11 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/5] SCSI and FireWire: fix/add START STOP UNIT for
	SBP-2 disks
Message-ID: <20080518173511.GA14742@dose.home.local>
Mail-Followup-To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux1394-devel@lists.sourceforge.net,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20080429232606.GA14261@dose.home.local> <481874BD.5010807@s5r6.in-berlin.de> <20080507180042.GA32629@dose.home.local> <tkrat.327b59f1366f8ea0@s5r6.in-berlin.de> <tkrat.635f52f7035be2bc@s5r6.in-berlin.de> <tkrat.5cf7605228f0006a@s5r6.in-berlin.de> <20080516062315.GA4350@dose.home.local> <tkrat.ad2cb91dd8644559@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tkrat.ad2cb91dd8644559@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 19:43:43 +0200, Stefan Richter wrote:
> Tino Keitel wrote:
> > I applied all patches, and tried it on my system with a SATA, USB and
> > Firewire disk. All disks spun down at suspend, and spun up again at
> > resume.
> 
> So can I add "Tested-by: Tino Keitel <tino.keitel@gmx.de>" to the
> changelog of patches 1/5, 2/5, 4/5 (the patches affecting sd and
> fw-sbp2)?

Yes.

Now I need to figure out how to get the Firewire disk to spin down
using HAL. It looks like HAL just uses /usr/bin/eject, which just sends
a START STOP UNIT command without power conditions set, so the kernel
can't do anything here.

Regards,
Tino
