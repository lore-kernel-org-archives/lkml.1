Return-Path: <linux-kernel-owner+w=401wt.eu-S934051AbXFGRWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934051AbXFGRWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 13:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762324AbXFGRWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:22:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758820AbXFGRWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 13:22:00 -0400
Message-ID: <46683E4D.9060801@redhat.com>
Date: Thu, 07 Jun 2007 13:20:13 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Tejun Heo <htejun@gmail.com>, Mikael Pettersson <mikpe@it.uu.se>,
       akpm@linux-foundation.org, david@dgreaves.com,
       jean.luc.coulon@gmail.com, jgarzik@pobox.com,
       michal.k.k.piotrowski@gmail.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [REPOST PATCH] sata_promise: use TF interface for polling NODATA
 commands
References: <200706052131.l55LVkYN000191@harpo.it.uu.se> <20070605215256.GT31565@havoc.gtf.org> <46665AB5.6040508@gmail.com> <20070606102122.GD29122@htj.dyndns.org> <20070606160511.GA23143@havoc.gtf.org>
In-Reply-To: <20070606160511.GA23143@havoc.gtf.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2007 12:05 PM, Jeff Garzik wrote:
> FYI to all -- 
> 
> As a reminder. the Promise hardware programs registers when it receives
> a SET FEATURES - XFER MODE.
> 
> If data transfer is occurring on OTHER ports at the time this is issued,
> then data corruption is guaranteed to occur.  Polling will not fix this
> problem -- all ports need to be inactive, when a SET FEATURES - XFER
> MODE command is issued for any port.
> 

So is this patch OK but yet more work needs to be done, or does
this patch cause new problems?
