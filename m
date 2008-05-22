Return-Path: <linux-kernel-owner+w=401wt.eu-S934115AbYEVXrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934115AbYEVXrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 19:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759961AbYEVXqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 19:46:46 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41579 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756791AbYEVXqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 19:46:45 -0400
Subject: Re: [Bug #10622] [BUG 2.6.26-rc1] scsi (or sysfs or vm?) oops in
	sr_probe()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dan Williams <dan.j.williams@intel.com>, Jeff Garzik <jeff@garzik.org>
In-Reply-To: <7wuznNhcUqC.A.ItB.2tBMIB@albercik>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
	 <7wuznNhcUqC.A.ItB.2tBMIB@albercik>
Content-Type: text/plain
Date: Thu, 22 May 2008 12:50:36 +0100
Message-Id: <1211457036.3956.44.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-05-18 at 13:13 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10622
> Subject		: [BUG 2.6.26-rc1] scsi (or sysfs or vm?) oops in sr_probe()
> Submitter	: Jeff Garzik <jeff@garzik.org>
> Date		: 2008-05-04 07:22 (15 days old)
> References	: http://lkml.org/lkml/2008/5/4/76
> Handled-By	: James Bottomley <James.Bottomley@hansenpartnership.com>
> 		  Dan Williams <dan.j.williams@intel.com>

I've been unable to get the reporter to respond to basic debugging
inquiries about this.  Without that information, my best guess is that
it's a kmalloc failure that ordinarily would be a mm issue.  However,
given that there have been no other reports of this, I suspect it might
be some type of one off error.

I'd downgrade the severity to not reproducible and kill it unless any
further information comes along.

James


