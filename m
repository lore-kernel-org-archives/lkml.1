Return-Path: <linux-kernel-owner+w=401wt.eu-S1767307AbXCIOIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767307AbXCIOIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 09:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767305AbXCIOH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 09:07:59 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:56461 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767299AbXCIOH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 09:07:58 -0500
Message-ID: <45F16A3C.3020201@garzik.org>
Date: Fri, 09 Mar 2007 09:07:56 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: linux-ide@vger.kernel.org, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iomap: implement pcim_iounmap_regions()
References: <20070309104558.GE32687@htj.dyndns.org>
In-Reply-To: <20070309104558.GE32687@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Implement pcim_iounmap_regions() - the opposite of
> pcim_iomap_regions().
> 
> Signed-off-by: Tejun heo <htejun@gmail.com>
> ---
> This one is used by libata's new init model and generally useful for
> driver midlayers.  Please push it through libata-dev#upstream.
> 
> Thanks.
> 
>  include/linux/pci.h |    1 +
>  lib/devres.c        |   26 ++++++++++++++++++++++++++
>  2 files changed, 27 insertions(+), 0 deletions(-)

applied


