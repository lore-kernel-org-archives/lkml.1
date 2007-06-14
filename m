Return-Path: <linux-kernel-owner+w=401wt.eu-S1753014AbXFNPK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbXFNPK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 11:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbXFNPKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 11:10:50 -0400
Received: from jericho.provo.novell.com ([137.65.248.124]:53492 "EHLO
	jericho.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbXFNPKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 11:10:50 -0400
Message-ID: <46715A66.8030806@suse.de>
Date: Fri, 15 Jun 2007 00:10:30 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Greaves <david@dgreaves.com>, David Chinner <dgc@sgi.com>,
       xfs@oss.sgi.com,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression (xfs on raid6)
References: <200706020122.49989.rjw@sisk.pl> <46706968.7000703@dgreaves.com> <alpine.LFD.0.98.0706131507360.14121@woody.linux-foundation.org> <200706140115.58733.rjw@sisk.pl> <46714ECF.8080203@gmail.com>
In-Reply-To: <46714ECF.8080203@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> David, do you store the hibernation image on the RAID-6 array?  Can you
> post the captured kernel log when it locks up?

Never mind.  Just succeeded to reproduce it here.  It definitely has
something to do with the raid code.  ext3 on raid6 is showing the same
problem.  I'll report back as soon as I find out more.

-- 
tejun
