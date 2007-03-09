Return-Path: <linux-kernel-owner+w=401wt.eu-S1767230AbXCIMvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767230AbXCIMvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 07:51:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767233AbXCIMvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 07:51:10 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:55697 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767230AbXCIMvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 07:51:09 -0500
Message-ID: <45F15838.7040501@garzik.org>
Date: Fri, 09 Mar 2007 07:51:04 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] devres: release resources on device_del()
References: <20070309103419.GB32687@htj.dyndns.org>
In-Reply-To: <20070309103419.GB32687@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
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

applied to #upstream-fixes


