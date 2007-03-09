Return-Path: <linux-kernel-owner+w=401wt.eu-S1767165AbXCIK5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767165AbXCIK5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 05:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767167AbXCIK5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 05:57:33 -0500
Received: from jericho.provo.novell.com ([137.65.248.124]:54702 "EHLO
	jericho.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767165AbXCIK5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 05:57:32 -0500
X-Greylist: delayed 1220 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Mar 2007 05:57:32 EST
Message-ID: <45F138C8.40409@suse.de>
Date: Fri, 09 Mar 2007 19:36:56 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] devres: release resources on device_del()
References: <20070309103419.GB32687@htj.dyndns.org>
In-Reply-To: <20070309103419.GB32687@htj.dyndns.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Some platform devices are driven without driver attached, so managed
> resources can be acquired without driver attached.  Make sure such
> resources are released by calling devres_release_all() in
> device_del().
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
> This one fixes oops on pata_platform and pata_legacy unload.  libata
> being the only user of devres at the moment.  I think this can go
> through libata-dev#upstream.

I meant libata-dev#upstream-fixes.  This needs to be fixed in 2.6.21.

-- 
tejun
