Return-Path: <linux-kernel-owner+w=401wt.eu-S1763323AbXHXVdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763323AbXHXVdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 17:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756646AbXHXVdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 17:33:06 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59848 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758127AbXHXVdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 17:33:05 -0400
Subject: Re: DM_MULTIPATH_RDAC: "scsi_normalize_sense" undefined
From: Chandra Seetharaman <sekharan@us.ibm.com>
Reply-To: sekharan@us.ibm.com
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org
In-Reply-To: <20070824160834.GA7029@deprecation.cyrius.com>
References: <20070824160834.GA7029@deprecation.cyrius.com>
Content-Type: text/plain
Organization: IBM
Date: Fri, 24 Aug 2007 14:33:02 -0700
Message-Id: <1187991182.17399.336.camel@linuxchandra>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It does, but "rdac" _is_ for a SCSI device.

What device are you using it with ?

On Fri, 2007-08-24 at 18:08 +0200, Martin Michlmayr wrote:
> I just got:
> 
>   Building modules, stage 2.
>   MODPOST 414 modules
> ERROR: "scsi_normalize_sense" [drivers/md/dm-rdac.ko] undefined!
> make[1]: *** [__modpost] Error 1
> 
> Presumably DM_MULTIPATH_RDAC needs to depend on SCSI (not enabled
> here) since it uses scsi_normalize_sense.
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------


