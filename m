Return-Path: <linux-kernel-owner+w=401wt.eu-S1753134AbZL2QfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbZL2QfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 11:35:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbZL2QfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 11:35:16 -0500
Received: from broadrack.ru ([195.178.208.66]:40728 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbZL2QfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 11:35:14 -0500
Date: Tue, 29 Dec 2009 19:35:12 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [Bug #14894] pohmelfs: NULL pointer dereference
Message-ID: <20091229163512.GA4958@ioremap.net>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera> <srmJ8vMxKPH.A.iAC.TwhOLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <srmJ8vMxKPH.A.iAC.TwhOLB@chimera>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 29, 2009 at 04:28:52PM +0100, Rafael J. Wysocki (rjw@sisk.pl) wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14894
> Subject		: pohmelfs: NULL pointer dereference
> Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
> Date		: 2009-12-02 1:11 (28 days old)
> References	: http://marc.info/?l=linux-kernel&m=125971633107940&w=4
> Handled-By	: Evgeniy Polyakov <zbr@ioremap.net>

Yes, I saw this regression and there is a patch to handle this, but it
kind of disables sync at all. Jens Axboe, who introduced per-bdi
writeback patches, did not yet reply.

-- 
	Evgeniy Polyakov
