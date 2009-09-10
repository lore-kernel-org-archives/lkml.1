Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbZIJT6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbZIJT6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 15:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbZIJT6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 15:58:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:43734 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239AbZIJT6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 15:58:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,366,1249282800"; 
   d="scan'208";a="447487610"
Subject: Re: linux-next: scsi tree build warnings
From: Robert Love <robert.w.love@intel.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <1252602497.11956.95.camel@mulgrave.site>
References: <20090907130024.d67c032d.sfr@canb.auug.org.au>
	 <1252602497.11956.95.camel@mulgrave.site>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 12:58:12 -0700
Message-Id: <1252612692.3384.10217.camel@fritz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 10:08 -0700, James Bottomley wrote:
> On Mon, 2009-09-07 at 13:00 +1000, Stephen Rothwell wrote:
> > Hi James,
> > 
> > Today's linux-next build (x86_64 allmodconfig) produced these warnings:
> > 
> > usr/include/scsi/fc/fc_els.h:165: found __[us]{8,16,32,64} type without #include <linux/types.h>
> > usr/include/scsi/fc/fc_fs.h:32: found __[us]{8,16,32,64} type without #include <linux/types.h>
> > usr/include/scsi/fc/fc_gs.h:29: found __[us]{8,16,32,64} type without #include <linux/types.h>
> > usr/include/scsi/fc/fc_ns.h:71: found __[us]{8,16,32,64} type without #include <linux/types.h>
> > 
> > Introduced by commit 171bb4f9f6a20d405a3cb5111ce92ad83aae2302 ("[SCSI]
> > libfc: Export FC headers").
> 
> OK, I've dropped this patch ... Robert, can you resubmit it when you've
> verified it all works.
> 
Yes, I'll fix this and resubmit.

