Return-Path: <linux-kernel-owner+w=401wt.eu-S965277AbXBTQDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965277AbXBTQDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965264AbXBTQDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:03:44 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44237 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965256AbXBTQDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:03:43 -0500
Message-ID: <45DB1BDB.3070901@garzik.org>
Date: Tue, 20 Feb 2007 11:03:39 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Markus Trippelsdorf <markus@trippelsdorf.de>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sata_via: fix resource-managed iomap conversion
References: <20070210010914.GA19717@havoc.gtf.org> <20070210054629.GA4395@gentoox2.trippelsdorf.de> <45CF93D1.9080009@gmail.com> <20070212025843.GA4406@gentoox2.trippelsdorf.de> <45D0B740.9050704@gmail.com> <20070220110153.GO1625@htj.dyndns.org>
In-Reply-To: <20070220110153.GO1625@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Conversion to resource-managed iomap was buggy causing init failures
> on both vt6420 and 6421 - BAR5 wasn't mapped for both controllers
> while on vt6420 sata_via tried to map BAR0-4 twice.  Fix it.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
> I thought I have a vt6421 but mine too was a vt6420.  So, the patch is
> verified only for vt6420 but, the vt6421 path is pretty obvious and
> should be correct.  Please apply.

applied


