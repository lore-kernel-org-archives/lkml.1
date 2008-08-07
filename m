Return-Path: <linux-kernel-owner+w=401wt.eu-S1758034AbYHGGbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbYHGGbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 02:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755978AbYHGGbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 02:31:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52012 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756453AbYHGGbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 02:31:17 -0400
Message-ID: <489A96B2.4030903@pobox.com>
Date: Thu, 07 Aug 2008 02:31:14 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Matti Linnanvuori <mattilinn@gmail.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1.2.32] WAN: merge driver retina
References: <ca0148c30807032339o4182fbadq370f709a28861053@mail.gmail.com>
In-Reply-To: <ca0148c30807032339o4182fbadq370f709a28861053@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matti Linnanvuori wrote:
> The following patch is based on linux-next:
> http://pcidriver.googlegroups.com/web/retina-patch.txt?gda=Hj6V2UEAAAD9a223ZdyQxc6jQf5toR434ka3fTOuf9SStRjUQ9KuyGG1qiJ7UbTIup-M2XPURDRb8A7WwO6f6JZwMwSZaAwRMXXBcZFbXU7ojtsMSuO4sA
> The build error and the warnings reported by David Miller have been fixed.

The version I reviewed uses virt_to_bus(), which should not be used in 
modern drivers.  The DMA API should be used instead.

A couple months ago I created a 'retina' branch of 
jgarzik/netdev-2.6.git containing your latest code.  If you could send 
patches against that, that would be helpful in reviewing the 
improvements you make to the driver, and help us get this into the kernel.

	Jeff



