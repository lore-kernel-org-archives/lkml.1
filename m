Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092AbZFERzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbZFERzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 13:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbZFERz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 13:55:29 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:6247 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbZFERz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 13:55:27 -0400
X-IronPort-AV: E=Sophos;i="4.41,312,1241395200"; 
   d="scan'208";a="173136894"
Date: Fri, 5 Jun 2009 10:55:30 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, greg@kroah.com, linux-scsi@vger.kernel.org,
       netdev@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH 5/5] initdev:kernel: USB and SCSI block init device
	notification, v3
Message-ID: <20090605175529.GA18688@cuplxvomd02.corp.sa.net>
References: <20090502023000.GA16076@cuplxvomd02.corp.sa.net> <20090502115539.396206bc@linux-lm> <20090505001950.GC29124@cuplxvomd02.corp.sa.net> <d82e647a0905042105g7639fc84g736668c371c40053@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d82e647a0905042105g7639fc84g736668c371c40053@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-2; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 12:05:19AM -0400, Ming Lei wrote:
> 2009/5/5 David VomLehn <dvomlehn@cisco.com>:
> > On Fri, May 01, 2009 at 11:55:39PM -0400, Ming Lei wrote:
> >> On Fri, 1 May 2009 19:30:00 -0700
> >> David VomLehn <dvomlehn@cisco.com> wrote:
> >>
> >> > From: Alan Stern <stern@rowland.harvard.edu
> >> > diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> >> > index 6f51ca4..735b061 100644
> >> > --- a/drivers/scsi/scsi_scan.c
> >> > +++ b/drivers/scsi/scsi_scan.c
> > ...
> >> > @@ -1834,6 +1834,7 @@ static int do_scan_async(void *_data)
> >> >     struct async_scan_data *data = _data;
> >> >     do_scsi_scan_host(data->shost);
> >> >     scsi_finish_async_scan(data);
> >> > +   initdev_probe_done(BOOTDEV_BLOCK_MASK);
> >>
> >> Which code are waiting for the block device's probe done?
> >
> > None yet. That remains to be done.
> >
> 
> Would you mind submitting  the code path of waitting for probe done to allow a
> intact review?  Without the waitting code, it is a a little difficult
> to undersand or verify
> your patch, IMHO.

This will be in the next spin of the patch, coming soon (possibly today).

> Thanks
> Lei Ming

David VomLehn
