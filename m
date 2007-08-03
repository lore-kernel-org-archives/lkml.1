Return-Path: <linux-kernel-owner+w=401wt.eu-S1761681AbXHCMDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761681AbXHCMDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 08:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbXHCMDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 08:03:33 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:48623 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbXHCMDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 08:03:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=jDCBDoMC4nk0YghY681/UvCutRwVE5TVX9qfr3O1NmagFeuDA9MysehmCiDf4ltbePflkqAS9a20MPYpdvKMxtlY5MGbh0jLJb3KzUrkMTW+7bZcbKdjSJQKiELPcfPQlFKkyCHVplS4XCX9OGUKpP6ZRY7oMsnabB7oFoBn6Is=
Message-ID: <46B31862.10201@gmail.com>
Date: Fri, 03 Aug 2007 20:58:26 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       mlord@pobox.com
Subject: Re: [PATCH] sata_qstor, pdc_adma, sata_sx4: convert to new EH
References: <20070724011404.GA14064@havoc.gtf.org>
In-Reply-To: <20070724011404.GA14064@havoc.gtf.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> This is just a refresh of the existing libata-dev.git#new-eh patches
> that convert all remaining old-EH drivers to new EH, against 2.6.23-rc1.
> 
> All three conversions are completely untested.  pdc_adma and sata_qstor
> need reviewing by someone with docs, in addition to testing.
> 
> Even "it still works" or "this patch breaks stuff" feedback from users
> is useful.

pdc_adma works fine.  Tested both a harddrive and a cdrom.  ATAPI check
sense seems to work and harddrive was successfully recovered from
timeout induced by shaking the harddisk for 30s.  :-)

-- 
tejun
