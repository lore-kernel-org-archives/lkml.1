Return-Path: <linux-kernel-owner+w=401wt.eu-S1760098AbXHQMgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098AbXHQMgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 08:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbXHQMgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 08:36:35 -0400
Received: from jaguar.mkp.net ([192.139.46.146]:59145 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754251AbXHQMgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 08:36:35 -0400
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Gregor Jasny <gjasny@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: Corrupted filesystem with new Firewire stack
From: "Martin K. Petersen" <mkp@mkp.net>
Organization: mkp.net
References: <9d2cd630708151447u7e415712u17e974859fbd5481@mail.gmail.com>
	<46C3EE1F.40309@s5r6.in-berlin.de>
Date: Fri, 17 Aug 2007 08:36:33 -0400
In-Reply-To: <46C3EE1F.40309@s5r6.in-berlin.de> (Stefan Richter's message of "Thu, 16 Aug 2007 08:26:39 +0200")
Message-ID: <yq1ps1m5odq.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Stefan" == Stefan Richter <stefanr@s5r6.in-berlin.de> writes:

Stefan> There were some similar reports involving that "status write
Stefan> for unknown orb".  I haven't found a way to reproduce it; I
Stefan> noticed it only once in the logs here so far.

I get those all the time.  Just do heavy ext3 I/O to the drive.

Happens here on both a G4 and an intel Mini.  Both running FC7.

Aug 17 08:24:08 mini kernel: firewire_sbp2: status write for unknown orb
Aug 17 08:25:08 mini kernel: firewire_sbp2: sbp2_scsi_abort
Aug 17 08:26:36 mini kernel: firewire_sbp2: status write for unknown orb
Aug 17 08:27:36 mini kernel: firewire_sbp2: sbp2_scsi_abort
Aug 17 08:33:51 mini kernel: firewire_sbp2: status write for unknown orb
Aug 17 08:34:51 mini kernel: firewire_sbp2: sbp2_scsi_abort

Lacie drive in both cases.

-- 
Martin K. Petersen      http://mkp.net/
