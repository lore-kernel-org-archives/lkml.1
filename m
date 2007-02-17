Return-Path: <linux-kernel-owner+w=401wt.eu-S965316AbXBQQfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965316AbXBQQfe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 11:35:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965317AbXBQQfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:35:34 -0500
Received: from lazybastard.de ([212.112.238.170]:55766 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965316AbXBQQfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:35:33 -0500
Date: Sat, 17 Feb 2007 15:11:08 +0000
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Juan Piernas Canovas <piernas@ditec.um.es>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, sfaibish <sfaibish@emc.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
Message-ID: <20070217151108.GA301@lazybastard.org>
References: <op.tnkdlbgsrwwil4@brcsmondepl2c.corp.emc.com> <op.tnrbrocsunckof@usensfaibisl2e.eng.emc.com> <Pine.LNX.4.61.0702142251460.19368@yvahk01.tjqt.qr> <Pine.LNX.4.61.0702151910370.19998@ditec.inf.um.es> <20070215200922.GB24643@lazybastard.org> <Pine.LNX.4.61.0702152353060.19998@ditec.inf.um.es> <20070216091321.GA28092@lazybastard.org> <45D642A4.5010009@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45D642A4.5010009@tmr.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 February 2007 18:47:48 -0500, Bill Davidsen wrote:
> >
> Actually I am interested in the common case, where the machine is not 
> out of space, or memory, or CPU, but when it is appropriately sized to 
> the workload. Not that I lack interest in corner cases, but the "running 
> flat out" case doesn't reflect case where there's enough hardware, now 
> the o/s needs to use it well.

There is one detail about this specific corner case you may be missing.
Most log-structured filesystems don't just drop in performance - they
can run into a deadlock and the only recovery from this is the lovely
backup-mkfs-restore procedure.

If it was just performance, I would agree with you.

Jörn

-- 
He that composes himself is wiser than he that composes a book.
-- B. Franklin
