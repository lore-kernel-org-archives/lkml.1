Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbYL2V6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbYL2V6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 16:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbYL2V6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 16:58:12 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58670 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259AbYL2V6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 16:58:11 -0500
Subject: Re: [PATCH -next v2] cxgb3i: use same dependencies & selects as
	CHELSIO_T3
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: scsi <linux-scsi@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       kxie@chelsio.com, akpm <akpm@linux-foundation.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081229132312.10934479.randy.dunlap@oracle.com>
References: <20081230031621.60acd90b.sfr@canb.auug.org.au>
	 <20081229130110.67d5271a.randy.dunlap@oracle.com>
	 <20081229132312.10934479.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Mon, 29 Dec 2008 15:58:07 -0600
Message-Id: <1230587887.3302.70.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-29 at 13:23 -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Make the CXGB iSCSI driver (that selects the CXGB net driver) have the same
> dependencies as the net driver, since kconfig doesn't do that automatically.
> Also make it select INET_LRO & FW_LOADER like the net driver does.

I thought select of a symbol that selected something else propagated
correctly (even if select of a symbol that depends on something else
doesn't).   If this is untrue, we have several other Kconfig problems in
the kernel.

James


