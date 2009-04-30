Return-Path: <linux-kernel-owner+w=401wt.eu-S1758791AbZD3Bn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791AbZD3Bn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 21:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbZD3BnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 21:43:14 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:15755 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbZD3BnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 21:43:12 -0400
X-IronPort-AV: E=Sophos;i="4.40,269,1238976000"; 
   d="scan'208";a="295495092"
Date: Wed, 29 Apr 2009 18:43:11 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-usb@vger.kernel.org, gregkh@suse.de, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] USB: Wait for USB and SCSI block boot devices
Message-ID: <20090430014311.GA30287@cuplxvomd02.corp.sa.net>
References: <20090430001255.GA3897@cuplxvomd02.corp.sa.net> <20090430013526.GD8822@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430013526.GD8822@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-1; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 07:35:26PM -0600, Matthew Wilcox wrote:
> On Wed, Apr 29, 2009 at 05:12:55PM -0700, David VomLehn wrote:
> >  	scsi_finish_async_scan(data);
> > +	bootdev_probe_done(BOOTDEV_BLOCK_MASK);
> >  	return 0;
> >  }
> >  
> > @@ -1855,6 +1856,7 @@ void scsi_scan_host(struct Scsi_Host *shost)
> >  		return;
> >  	}
> >  
> > +	bootdev_found(BOOTDEV_BLOCK_MASK);
> >  	p = kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
> >  	if (IS_ERR(p))
> 
> Where are the definitions of these functions to be found?

My email has been on the flaky side and I may not have sent them to all the
right places. I'll resend.

> Matthew Wilcox				Intel Open Source Technology Centre
