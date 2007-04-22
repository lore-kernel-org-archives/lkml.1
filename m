Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389AbXDVViO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbXDVViO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 17:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbXDVViO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 17:38:14 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:43766 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752389AbXDVViN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 17:38:13 -0400
Subject: Re: [PATCH] sas_scsi_host: Convert to use the kthread API
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
In-Reply-To: <20070422193843.GA17841@infradead.org>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	 <11769695611073-git-send-email-ebiederm@xmission.com>
	 <20070419173753.8ba2f955.akpm@linux-foundation.org>
	 <20070422193843.GA17841@infradead.org>
Content-Type: text/plain
Date: Sun, 22 Apr 2007 16:37:48 -0500
Message-Id: <1177277868.4268.16.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-22 at 20:38 +0100, Christoph Hellwig wrote:
> On Thu, Apr 19, 2007 at 05:37:53PM -0700, Andrew Morton wrote:
> > On Thu, 19 Apr 2007 01:58:38 -0600
> > "Eric W. Biederman" <ebiederm@xmission.com> wrote:
> > 
> > > From: Eric W. Biederman <ebiederm@xmission.com>
> > > 
> > > This patch modifies the sas scsi host thread startup
> > > to use kthread_run not kernel_thread and deamonize.
> > > kthread_run is slightly simpler and more maintainable.
> > > 
> > 
> > Again, I'll rename this to "partially convert...".  This driver should be
> > using kthread_should_stop() and kthread_stop() rather than the
> > apparently-unnecessary ->queue_thread_kill thing.
> > 
> > This driver was merged two and a half years after the kthread API was
> > available.   Our coding-vs-reviewing effort is out of balance.
> 
> Here's a full conversion.

Changelog and cc to linux-scsi, and I think it can go in ... not that it
matters; nothing ever activates this code inside libsas anyway ...

James


