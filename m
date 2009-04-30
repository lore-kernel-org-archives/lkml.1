Return-Path: <linux-kernel-owner+w=401wt.eu-S1759405AbZD3Bfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405AbZD3Bfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 21:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbZD3Bf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 21:35:29 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:53547 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbZD3Bf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 21:35:29 -0400
Date: Wed, 29 Apr 2009 19:35:26 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: David VomLehn <dvomlehn@cisco.com>
Cc: linux-usb@vger.kernel.org, gregkh@suse.de, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] USB: Wait for USB and SCSI block boot devices
Message-ID: <20090430013526.GD8822@parisc-linux.org>
References: <20090430001255.GA3897@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430001255.GA3897@cuplxvomd02.corp.sa.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 05:12:55PM -0700, David VomLehn wrote:
>  	scsi_finish_async_scan(data);
> +	bootdev_probe_done(BOOTDEV_BLOCK_MASK);
>  	return 0;
>  }
>  
> @@ -1855,6 +1856,7 @@ void scsi_scan_host(struct Scsi_Host *shost)
>  		return;
>  	}
>  
> +	bootdev_found(BOOTDEV_BLOCK_MASK);
>  	p = kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
>  	if (IS_ERR(p))

Where are the definitions of these functions to be found?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
