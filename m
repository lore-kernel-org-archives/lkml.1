Return-Path: <linux-kernel-owner+w=401wt.eu-S1753702AbZIJT12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbZIJT12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 15:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbZIJT10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 15:27:26 -0400
Received: from 139-142-54-143.atc.vaillant.ca ([139.142.54.143]:55801 "EHLO
	quartz.edm.orcorp.ca" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753650AbZIJT1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 15:27:22 -0400
Date: Thu, 10 Sep 2009 13:27:21 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: James Morris <jmorris@namei.org>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       tpmdd-devel@lists.sourceforge.net,
       Debora Velarde <debora@linux.vnet.ibm.com>,
       Marcel Selhorst <m.selhorst@sirrix.com>,
       Jan Beulich <jbeulich@novell.com>, adi@vmware.com, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] TPM: Fixup boot probe timeout for tpm_tis driver
Message-ID: <20090910192721.GA7552@obsidianresearch.com>
References: <20090909232218.GK406@obsidianresearch.com> <1252545267.4837.62.camel@blackbox> <alpine.LRH.2.00.0909101919400.3312@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0909101919400.3312@tundra.namei.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 07:21:33PM +1000, James Morris wrote:
> On Wed, 9 Sep 2009, Rajiv Andrade wrote:
 
> > Andy Isaacson sent this a while ago in a patchset, I think I lost track
> > of it in the middle of the other patches, sorry. In any case, ACK.

Thanks Rajiv

> This will be pushed to Linus within the next day as part of the merge for 
> 2.6.32, and I'm guessing needs to be in -stable.

Thanks - as for -stable I'm expecting not many people are affected by
this, but I doubt it hurts anything. This is actually fixing a
regression introduced by 05a462afe80553550bc77afc724ce60b42ad587e if
that matters.

Jason
