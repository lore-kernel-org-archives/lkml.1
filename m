Return-Path: <linux-kernel-owner+w=401wt.eu-S1758200AbYD2Ghe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbYD2Ghe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 02:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbYD2GhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 02:37:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60855 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbYD2GhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 02:37:25 -0400
Message-ID: <4816C214.60806@pobox.com>
Date: Tue, 29 Apr 2008 02:37:08 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Kumar Gala <galak@kernel.crashing.org>, Andrew Morton <akpm@osdl.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] devres: support addresses greater than an unsigned long
 via dev_ioremap
References: <Pine.LNX.4.64.0804290122210.10928@blarg.am.freescale.net> <4816C094.6030601@gmail.com>
In-Reply-To: <4816C094.6030601@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Kumar Gala wrote:
>> Use a resource_size_t instead of unsigned long since some arch's are
>> capable of having ioremap deal with addresses greater than the size of a
>> unsigned long.
>>
>> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> 
> Acked-by: Tejun Heo <htejun@gmail.com>

Fine with me, too.

I think devres changes should go via GregKH (device core) or Jesse (PCI) 
rather than my libata tree, unless there are obvious dependencies...

	Jeff



